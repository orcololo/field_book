import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';

import '../../models/collection_method.dart';
import '../../models/collection_session.dart';
import '../../models/determination.dart';
import '../../models/gps_point.dart';
import '../../models/measurement.dart';
import '../../models/phenological_state.dart';
import '../../models/photo_metadata.dart';
import '../../models/plant_category.dart';
import '../../models/plant_record.dart';
import '../../models/sync_metadata.dart';
import '../database/isar_service.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../services/media_upload_service.dart';

final _log = Logger(printer: PrettyPrinter(methodCount: 0));

/// Result of a sync cycle.
class SyncResult {
  final int pushed;
  final int pulled;
  final int conflicts;
  final int errors;
  final List<String> errorMessages;

  /// True when the sync cycle was skipped (e.g., device is offline).
  /// UI should NOT update "last synced" when this is true.
  final bool skipped;

  const SyncResult({
    this.pushed = 0,
    this.pulled = 0,
    this.conflicts = 0,
    this.errors = 0,
    this.errorMessages = const [],
    this.skipped = false,
  });

  SyncResult operator +(SyncResult other) => SyncResult(
    pushed: pushed + other.pushed,
    pulled: pulled + other.pulled,
    conflicts: conflicts + other.conflicts,
    errors: errors + other.errors,
    errorMessages: [...errorMessages, ...other.errorMessages],
    skipped: skipped && other.skipped,
  );

  bool get hasErrors => errors > 0;
}

/// Core sync orchestrator: pushes local changes, then pulls remote changes.
class SyncService {
  final ApiClient _api;
  final MediaUploadService _mediaUpload;
  final Connectivity _connectivity;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  SyncService({
    required ApiClient api,
    required MediaUploadService mediaUpload,
    Connectivity? connectivity,
  }) : _api = api,
       _mediaUpload = mediaUpload,
       _connectivity = connectivity ?? Connectivity();

  /// Run a full sync cycle: upload media → push changes → pull remote.
  Future<SyncResult> sync({String? deviceId}) async {
    if (_isSyncing) return const SyncResult();

    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      _log.d('Offline — skipping sync');
      return const SyncResult(skipped: true);
    }

    _isSyncing = true;
    try {
      final pushResult = await _push(deviceId: deviceId);
      final pullResult = await _pull();
      return pushResult + pullResult;
    } finally {
      _isSyncing = false;
    }
  }

  Map<String, dynamic> buildPlantConflictLocalData(PlantRecord plant) {
    return {
      ..._plantToSyncJson(plant),
      'id': plant.syncMetadata.serverId,
      'syncVersion': plant.syncMetadata.syncVersion,
      'updatedAt': plant.updatedAt.toIso8601String(),
      'localModifiedAt': (plant.syncMetadata.localModifiedAt ?? plant.updatedAt)
          .toIso8601String(),
    };
  }

  Future<void> keepLocalConflict(PlantRecord plant) async {
    final isar = await IsarService.instance.isar;
    final current = await isar.plantRecords.get(plant.id);
    if (current == null) return;

    await _finishConflictResolution(
      current,
      syncVersion:
          _decodeConflictData(current.syncMetadata.conflictData)['syncVersion']
              as num?,
      serverId:
          _decodeConflictData(current.syncMetadata.conflictData)['id']
              as String?,
    );
  }

  Future<void> acceptServerConflict(PlantRecord plant) async {
    final isar = await IsarService.instance.isar;
    final current = await isar.plantRecords.get(plant.id);
    if (current == null) return;

    final serverData = _decodeConflictData(current.syncMetadata.conflictData);
    if (serverData.isEmpty) {
      await keepLocalConflict(current);
      return;
    }

    _applyRemoteDataToPlant(current, serverData);
    await _finishConflictResolution(
      current,
      syncVersion: serverData['syncVersion'] as num?,
      serverId: serverData['id'] as String?,
    );
  }

  Future<void> resolvePlantConflictWithData(
    PlantRecord plant,
    Map<String, dynamic> resolvedData,
  ) async {
    final isar = await IsarService.instance.isar;
    final current = await isar.plantRecords.get(plant.id);
    if (current == null) return;

    _applyRemoteDataToPlant(current, resolvedData);
    await _finishConflictResolution(
      current,
      syncVersion: resolvedData['syncVersion'] as num?,
      serverId: resolvedData['id'] as String?,
    );
  }

  Future<void> resolveAllConflictsKeepMostRecent() async {
    final isar = await IsarService.instance.isar;
    final conflicts = await isar.plantRecords
        .filter()
        .syncMetadata((q) => q.syncStatusEqualTo(SyncStatus.conflict))
        .findAll();

    for (final plant in conflicts) {
      final serverData = _decodeConflictData(plant.syncMetadata.conflictData);
      final localModifiedAt =
          plant.syncMetadata.localModifiedAt ?? plant.updatedAt;
      final serverModifiedAt = _extractServerModifiedAt(serverData);

      if (serverModifiedAt != null &&
          serverModifiedAt.isAfter(localModifiedAt)) {
        _applyRemoteDataToPlant(plant, serverData);
        await _finishConflictResolution(
          plant,
          syncVersion: serverData['syncVersion'] as num?,
          serverId: serverData['id'] as String?,
        );
        continue;
      }

      await _finishConflictResolution(
        plant,
        syncVersion: serverData['syncVersion'] as num?,
        serverId: serverData['id'] as String?,
      );
    }
  }

  // ── Push ──────────────────────────────────────────────

  Future<SyncResult> _push({String? deviceId}) async {
    final isar = await IsarService.instance.isar;

    // Gather pending plants
    final pendingPlants = await isar.plantRecords
        .filter()
        .syncMetadata((q) => q.syncStatusEqualTo(SyncStatus.pending))
        .findAll();

    // Gather pending sessions
    final pendingSessions = await isar.collectionSessions
        .filter()
        .syncMetadata((q) => q.syncStatusEqualTo(SyncStatus.pending))
        .findAll();

    if (pendingPlants.isEmpty && pendingSessions.isEmpty) {
      return const SyncResult();
    }

    _log.i(
      'Pushing ${pendingPlants.length} plants, ${pendingSessions.length} sessions',
    );

    // Upload media for each plant before push
    final plantsReadyToPush = <PlantRecord>[];
    for (final plant in pendingPlants) {
      final allUploaded = await _uploadPlantMedia(plant);
      if (allUploaded) {
        plantsReadyToPush.add(plant);
      } else {
        _log.w(
          'Plant ${plant.uuid} has unuploaded media, skipping push',
        );
      }
    }

    if (plantsReadyToPush.isEmpty && pendingSessions.isEmpty) {
      return const SyncResult();
    }

    // Build push payload
    final registries = plantsReadyToPush.map(_plantToSyncJson).toList();
    final sessions = pendingSessions.map(_sessionToSyncJson).toList();

    try {
      final data = await _api.post<Map<String, dynamic>>(
        ApiEndpoints.syncPush,
        data: {
          'registries': registries,
          'sessions': sessions,
          'deviceId': deviceId ?? '',
        },
      );

      int pushed = 0;
      int conflicts = 0;
      int errors = 0;
      final errorMessages = <String>[];

      // Process registry results
      final regResults = data['registries'] as List? ?? [];
      for (var i = 0; i < regResults.length; i++) {
        final result = regResults[i] as Map<String, dynamic>;
        final status = result['status'] as String;
        if (status == 'created' || status == 'updated') {
          pushed++;
          await _markPlantSynced(plantsReadyToPush[i], result);
        } else if (status == 'conflict') {
          conflicts++;
          await _markPlantConflict(plantsReadyToPush[i], result);
        } else {
          errors++;
          errorMessages.add(result['error']?.toString() ?? 'Unknown error');
        }
      }

      // Process session results
      final sesResults = data['sessions'] as List? ?? [];
      for (var i = 0; i < sesResults.length; i++) {
        final result = sesResults[i] as Map<String, dynamic>;
        final status = result['status'] as String;
        if (status == 'created' || status == 'updated') {
          pushed++;
          await _markSessionSynced(pendingSessions[i], result);
        } else if (status == 'conflict') {
          conflicts++;
        } else {
          errors++;
        }
      }

      return SyncResult(
        pushed: pushed,
        conflicts: conflicts,
        errors: errors,
        errorMessages: errorMessages,
      );
    } catch (e) {
      _log.e('Push failed: $e');
      return SyncResult(errors: 1, errorMessages: [e.toString()]);
    }
  }

  // ── Pull ──────────────────────────────────────────────

  Future<SyncResult> _pull() async {
    final isar = await IsarService.instance.isar;
    int pulled = 0;

    try {
      // Find the latest sync timestamp across all records
      DateTime? since;
      final allSynced = await isar.plantRecords
          .filter()
          .syncMetadata((q) => q.lastSyncedAtIsNotNull())
          .findAll();
      if (allSynced.isNotEmpty) {
        allSynced.sort((a, b) {
          final aDate = a.syncMetadata.lastSyncedAt ?? DateTime(0);
          final bDate = b.syncMetadata.lastSyncedAt ?? DateTime(0);
          return bDate.compareTo(aDate);
        });
        since = allSynced.first.syncMetadata.lastSyncedAt;
      }

      bool hasMore = true;
      while (hasMore) {
        final params = <String, dynamic>{'limit': 100};
        if (since != null) {
          params['since'] = since.toIso8601String();
        }

        final data = await _api.get<Map<String, dynamic>>(
          ApiEndpoints.syncPull,
          queryParameters: params,
        );

        final regList = data['registries'] as List? ?? [];
        final sesList = data['sessions'] as List? ?? [];

        for (final json in regList) {
          await _upsertPlantFromRemote(json as Map<String, dynamic>);
          pulled++;
        }

        for (final json in sesList) {
          await _upsertSessionFromRemote(json as Map<String, dynamic>);
          pulled++;
        }

        hasMore = data['hasMore'] as bool? ?? false;
        if (hasMore) {
          // Advance the cursor
          final lastUpdated = data['lastUpdatedAt'] as String?;
          if (lastUpdated != null) {
            since = DateTime.parse(lastUpdated);
          } else {
            hasMore = false;
          }
        }
      }
    } catch (e) {
      _log.e('Pull failed: $e');
      return SyncResult(
        pulled: pulled,
        errors: 1,
        errorMessages: [e.toString()],
      );
    }

    return SyncResult(pulled: pulled);
  }

  // ── Media Upload ──────────────────────────────────────

  /// Uploads local media files for a plant record. Returns true if all media
  /// was uploaded successfully (or was already remote). Returns false if any
  /// local file failed to upload.
  Future<bool> _uploadPlantMedia(PlantRecord plant) async {
    bool allUploaded = true;

    final updatedPhotoPaths = <String>[];
    for (final path in plant.photoPaths) {
      if (path.startsWith('http')) {
        updatedPhotoPaths.add(path);
        continue;
      }
      final file = File(path);
      if (!file.existsSync()) {
        _log.w('Photo file not found, skipping: $path');
        continue;
      }
      try {
        final result = await _mediaUpload.uploadImage(file);
        updatedPhotoPaths.add(result.originalUrl);
      } catch (e) {
        _log.w('Failed to upload image $path: $e');
        updatedPhotoPaths.add(path);
        allUploaded = false;
      }
    }
    plant.photoPaths = updatedPhotoPaths;

    final updatedAudioPaths = <String>[];
    for (final path in plant.audioNotePaths) {
      if (path.startsWith('http')) {
        updatedAudioPaths.add(path);
        continue;
      }
      final file = File(path);
      if (!file.existsSync()) {
        _log.w('Audio file not found, skipping: $path');
        continue;
      }
      try {
        final result = await _mediaUpload.uploadAudio(file);
        updatedAudioPaths.add(result.originalUrl);
      } catch (e) {
        _log.w('Failed to upload audio $path: $e');
        updatedAudioPaths.add(path);
        allUploaded = false;
      }
    }
    plant.audioNotePaths = updatedAudioPaths;

    // Persist uploaded URLs immediately so they survive crashes
    final isar = await IsarService.instance.isar;
    await isar.writeTxn(() async {
      await isar.plantRecords.put(plant);
    });

    return allUploaded;
  }

  // ── JSON Mapping ──────────────────────────────────────

  Map<String, dynamic> _plantToSyncJson(PlantRecord plant) {
    return {
      'uuid': plant.uuid,
      'registryIdentifier': plant.registryIdentifier,
      'scientificName': plant.scientificName,
      'commonName': plant.commonName,
      'family': plant.family,
      'scientificAuthor': plant.scientificAuthor,
      'taxonStatus': plant.taxonStatus,
      'genus': plant.genus,
      'speciesEpithet': plant.species,
      'habitat': plant.habitat,
      'locality': plant.locality,
      'state': plant.state,
      'country': plant.country,
      'municipality': plant.municipality,
      'category': plant.category.name,
      'dateCollected': plant.dateCollected.toIso8601String(),
      'latitude': plant.latitude,
      'longitude': plant.longitude,
      'altitude': plant.altitude,
      'temperature': plant.temperature,
      'humidity': plant.humidity,
      'weatherCondition': plant.weatherCondition,
      'weatherNotes': plant.weatherNotes,
      'moonPhase': plant.moonPhase,
      'windSpeed': plant.windSpeed,
      'collectorNumber': plant.collectorNumber,
      'numberOfIndividuals': plant.numberOfIndividuals,
      'substrate': plant.substrate,
      'associatedTaxa': plant.associatedTaxa,
      'vegetationType': plant.vegetationType,
      'topography': plant.topography,
      'determinationQualifier': plant.determinationQualifier,
      'phenologicalState': plant.phenologicalState?.name,
      'phenologyFournier': plant.phenologyFournier,
      'collectionMethod': plant.collectionMethod?.name,
      'notes': plant.notes,
      'isDraft': plant.isDraft,
      'sessionId': plant.sessionId,
      'deviceId': plant.deviceId,
      'contributorName': plant.contributorName,
      'duplicateOf': plant.duplicateOf,
      'duplicateUuids': plant.duplicateUuids,
      'iNaturalistId': plant.iNaturalistId,
      'iNaturalistSyncedAt': plant.iNaturalistSyncedAt?.toIso8601String(),
      'determinations': plant.determinations
          .map(
            (determination) => {
              'determinedBy': determination.determinedBy,
              'determinedAt': determination.determinedAt.toIso8601String(),
              'scientificName': determination.scientificName,
              'family': determination.family,
              'notes': determination.notes,
              'basis': determination.basis,
            },
          )
          .toList(),
      'photoPaths': plant.photoPaths,
      'audioNotePaths': plant.audioNotePaths,
      'audioTranscripts': plant.audioTranscripts,
      'measurements': plant.measurements
          .map((m) => {'label': m.label, 'value': m.value, 'unit': m.unit})
          .toList(),
      'photoMetadata': plant.photoMetadata
          .map(
            (p) => {
              'exifDataJson': p.exifDataJson,
              'dateTaken': p.dateTaken?.toIso8601String(),
              'latitude': p.latitude,
              'longitude': p.longitude,
              'fileSize': p.fileSize,
            },
          )
          .toList(),
      'morphology': {
        'root': plant.raiz,
        'stem': {
          'type': plant.cauleTipoCasca,
          'color': plant.cauleCor,
          'size': _formatMeasurementWithUnit(
            plant.cauleTamanho,
            plant.cauleTamanhoUnidade,
          ),
          'circumference': _formatMeasurementWithUnit(
            plant.cauleCircunferencia,
            plant.cauleCircunferenciaUnidade,
          ),
          'sap': plant.cauleTemSeiva
              ? (plant.cauleDescricaoSeiva ?? 'sim')
              : null,
        },
        'leaf': {
          'bainha': plant.folhaBainha,
          'peciolo': plant.folhaPeciolo,
          'lamina': plant.folhaLamina,
        },
        'flower': {
          'inflorescence': plant.florInflorescencia,
          'color': plant.florCor,
          'size': _formatMeasurementWithUnit(
            plant.florTamanho,
            plant.florTamanhoUnidade,
          ),
        },
        'fruit': {
          'color': plant.frutoCor,
          'format': plant.frutoFormato,
          'size': _formatMeasurementWithUnit(
            plant.frutoTamanho,
            plant.frutoTamanhoUnidade,
          ),
        },
        'seed': {
          'format': plant.sementeFormato,
          'color': plant.sementeCor,
          'size': _formatMeasurementWithUnit(
            plant.sementeTamanho,
            plant.sementeTamanhoUnidade,
          ),
        },
      },
      'caule': plant.caule,
      'folhaDescricao': plant.folhaDescricao,
      'florDescricao': plant.florDescricao,
      'frutoDescricao': plant.frutoDescricao,
      'sementeDescricao': plant.sementeDescricao,
      'syncVersion': plant.syncMetadata.syncVersion,
      'localModifiedAt': plant.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _sessionToSyncJson(CollectionSession session) {
    return {
      'uuid': session.uuid,
      'tripName': session.tripName,
      'startDate': session.startDate.toIso8601String(),
      'endDate': session.endDate?.toIso8601String(),
      'location': session.location,
      'teamMembers': session.teamMembers,
      'shareCode': session.shareCode,
      'sharedWith': session.sharedWith,
      'notes': session.notes,
      'isArchived': session.isArchived,
      'track': session.track
          .map(
            (point) => {
              'latitude': point.latitude,
              'longitude': point.longitude,
              'altitude': point.altitude,
              'timestamp': point.timestamp.toIso8601String(),
            },
          )
          .toList(),
      'localModifiedAt': session.createdAt.toIso8601String(),
      'syncVersion': session.syncMetadata.syncVersion,
    };
  }

  // ── Sync Status Updates ───────────────────────────────

  Future<void> _markPlantSynced(
    PlantRecord plant,
    Map<String, dynamic> result,
  ) async {
    final isar = await IsarService.instance.isar;
    plant.syncMetadata
      ..syncStatus = SyncStatus.synced
      ..lastSyncedAt = DateTime.now()
      ..serverId = result['serverId'] as String?
      ..syncVersion =
          (result['syncVersion'] as num?)?.toInt() ??
          plant.syncMetadata.syncVersion;

    await isar.writeTxn(() async {
      await isar.plantRecords.put(plant);
    });
  }

  Future<void> _markPlantConflict(
    PlantRecord plant,
    Map<String, dynamic> result,
  ) async {
    final isar = await IsarService.instance.isar;
    plant.syncMetadata
      ..syncStatus = SyncStatus.conflict
      ..conflictData = jsonEncode(result['serverData']);

    await isar.writeTxn(() async {
      await isar.plantRecords.put(plant);
    });
  }

  Future<void> _markSessionSynced(
    CollectionSession session,
    Map<String, dynamic> result,
  ) async {
    final isar = await IsarService.instance.isar;
    session.syncMetadata
      ..syncStatus = SyncStatus.synced
      ..lastSyncedAt = DateTime.now()
      ..serverId = result['serverId'] as String?
      ..syncVersion =
          (result['syncVersion'] as num?)?.toInt() ??
          session.syncMetadata.syncVersion;

    await isar.writeTxn(() async {
      await isar.collectionSessions.put(session);
    });
  }

  // ── Remote → Local Upsert ────────────────────────────

  Future<void> _finishConflictResolution(
    PlantRecord plant, {
    num? syncVersion,
    String? serverId,
  }) async {
    final isar = await IsarService.instance.isar;
    plant.syncMetadata
      ..syncStatus = SyncStatus.synced
      ..conflictData = null
      ..lastSyncedAt = DateTime.now()
      ..serverId = serverId ?? plant.syncMetadata.serverId
      ..syncVersion = syncVersion?.toInt() ?? plant.syncMetadata.syncVersion;

    await isar.writeTxn(() async {
      await isar.plantRecords.put(plant);
    });
  }

  Map<String, dynamic> _decodeConflictData(String? conflictData) {
    if (conflictData == null || conflictData.isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final decoded = jsonDecode(conflictData);
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
    } catch (_) {
      _log.w('Invalid conflict data payload');
    }

    return <String, dynamic>{};
  }

  DateTime? _extractServerModifiedAt(Map<String, dynamic> serverData) {
    final raw =
        serverData['lastModifiedAt'] ??
        serverData['localModifiedAt'] ??
        serverData['updatedAt'];
    if (raw is! String || raw.isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
  }

  Future<void> _upsertPlantFromRemote(Map<String, dynamic> json) async {
    final isar = await IsarService.instance.isar;
    final uuid = json['uuid'] as String;

    var existing = await isar.plantRecords
        .filter()
        .uuidEqualTo(uuid)
        .findFirst();

    // If local copy is newer and pending, skip (will push on next cycle)
    if (existing != null &&
        existing.syncMetadata.syncStatus == SyncStatus.pending) {
      return;
    }

    final plant = existing ?? PlantRecord();
    if (existing == null) {
      plant.createdAt =
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now();
    }
    _applyRemoteDataToPlant(plant, json);
    plant.syncMetadata
      ..syncStatus = SyncStatus.synced
      ..lastSyncedAt = DateTime.now()
      ..serverId = json['id'] as String?
      ..syncVersion =
          ((json['syncMetadata'] as Map?)?['syncVersion'] as num?)?.toInt() ??
          plant.syncMetadata.syncVersion;

    await isar.writeTxn(() async {
      await isar.plantRecords.put(plant);
    });
  }

  void _applyRemoteDataToPlant(PlantRecord plant, Map<String, dynamic> json) {
    // When the backend populates the species ref the taxonomy lives on the
    // nested species object, not the top-level registry document.
    final speciesObj = _asStringDynamicMap(json['species']);

    plant
      ..uuid = json['uuid'] as String
      ..scientificName =
          json['scientificName'] as String? ??
          speciesObj?['scientificName'] as String? ??
          ''
      ..commonName =
          json['commonName'] as String? ??
          speciesObj?['commonName'] as String? ??
          ''
      ..family = json['family'] as String? ?? speciesObj?['family'] as String?
      ..scientificAuthor = json['scientificAuthor'] as String?
      ..taxonStatus = json['taxonStatus'] as String?
      ..genus = json['genus'] as String? ?? speciesObj?['genus'] as String?
      ..species = _extractSpeciesEpithet(json)
      ..habitat = json['habitat'] as String?
      ..locality = json['locality'] as String?
      ..state = json['state'] as String?
      ..country = json['country'] as String?
      ..municipality = json['municipality'] as String?
      ..registryIdentifier = json['registryIdentifier'] as String?
      ..notes = json['notes'] as String?
      ..isDraft = json['isDraft'] as bool? ?? true
      ..sessionId = json['sessionId'] as String?
      ..deviceId = json['deviceId'] as String? ?? ''
      ..contributorName = json['contributorName'] as String?
      ..duplicateOf = json['duplicateOf'] as String?
      ..dateCollected = DateTime.parse(
        json['dateCollected'] as String? ?? DateTime.now().toIso8601String(),
      )
      ..latitude = (json['latitude'] as num?)?.toDouble()
      ..longitude = (json['longitude'] as num?)?.toDouble()
      ..altitude = (json['altitude'] as num?)?.toDouble()
      ..temperature = (json['temperature'] as num?)?.toDouble()
      ..humidity = (json['humidity'] as num?)?.toDouble()
      ..weatherCondition = json['weatherCondition'] as String?
      ..weatherNotes = json['weatherNotes'] as String?
      ..moonPhase = json['moonPhase'] as String?
      ..windSpeed = (json['windSpeed'] as num?)?.toDouble()
      ..collectorNumber = json['collectorNumber'] as String?
      ..numberOfIndividuals = (json['numberOfIndividuals'] as num?)?.toInt()
      ..substrate = json['substrate'] as String?
      ..associatedTaxa = json['associatedTaxa'] as String?
      ..vegetationType = json['vegetationType'] as String?
      ..topography = json['topography'] as String?
      ..determinationQualifier = json['determinationQualifier'] as String?
      ..phenologyFournier = json['phenologyFournier'] as String?
      ..iNaturalistId = json['iNaturalistId'] as String?
      ..iNaturalistSyncedAt = json['iNaturalistSyncedAt'] != null
          ? DateTime.tryParse(json['iNaturalistSyncedAt'] as String)
          : null
      ..updatedAt = DateTime.now();

    final duplicateUuids = json['duplicateUuids'] as List?;
    if (duplicateUuids != null) {
      plant.duplicateUuids = duplicateUuids.cast<String>();
    }

    final determinations = json['determinations'] as List?;
    if (determinations != null) {
      plant.determinations = determinations.map((raw) {
        final determination = raw as Map;
        return Determination()
          ..determinedBy = determination['determinedBy'] as String? ?? ''
          ..determinedAt = DateTime.parse(
            determination['determinedAt'] as String? ??
                DateTime.now().toIso8601String(),
          )
          ..scientificName = determination['scientificName'] as String? ?? ''
          ..family = determination['family'] as String?
          ..notes = determination['notes'] as String?
          ..basis = determination['basis'] as String?;
      }).toList();
      plant.applyLatestDetermination();
    }

    final phenoRaw = json['phenologicalState'] as String?;
    if (phenoRaw != null) {
      plant.phenologicalState = PhenologicalState.values.firstWhere(
        (e) => e.name == phenoRaw,
        orElse: () => PhenologicalState.unknown,
      );
    }

    final methodRaw = json['collectionMethod'] as String?;
    if (methodRaw != null) {
      plant.collectionMethod = CollectionMethod.values.firstWhere(
        (e) => e.name == methodRaw,
        orElse: () => CollectionMethod.voucherCollected,
      );
    }

    final categoryRaw =
        json['category'] as String? ??
        _asStringDynamicMap(json['species'])?['category'] as String?;
    if (categoryRaw != null) {
      plant.category = PlantCategory.values.firstWhere(
        (e) => e.name == categoryRaw,
        orElse: () => PlantCategory.herbs,
      );
    }

    final measurements = json['measurements'] as List?;
    if (measurements != null) {
      plant.measurements = measurements.map((raw) {
        final m = raw as Map;
        return Measurement()
          ..label = m['label'] as String? ?? ''
          ..value = (m['value'] as num?)?.toDouble() ?? 0.0
          ..unit = m['unit'] as String? ?? '';
      }).toList();
    }

    final photoMetadataList = json['photoMetadata'] as List?;
    if (photoMetadataList != null) {
      plant.photoMetadata = photoMetadataList.map((raw) {
        final p = raw as Map;
        return PhotoMetadata()
          ..exifDataJson = p['exifDataJson'] as String? ?? '{}'
          ..dateTaken = p['dateTaken'] != null
              ? DateTime.tryParse(p['dateTaken'] as String)
              : null
          ..latitude = (p['latitude'] as num?)?.toDouble()
          ..longitude = (p['longitude'] as num?)?.toDouble()
          ..fileSize = (p['fileSize'] as num?)?.toInt() ?? 0;
      }).toList();
    }

    plant.updateFtsFields();

    final remotePaths = json['photoPaths'] as List?;
    if (remotePaths != null) {
      plant.photoPaths = remotePaths.cast<String>();
    }
    final remoteAudio = json['audioNotePaths'] as List?;
    if (remoteAudio != null) {
      plant.audioNotePaths = remoteAudio.cast<String>();
    }
    final remoteTranscripts = json['audioTranscripts'] as List?;
    if (remoteTranscripts != null) {
      plant.audioTranscripts = remoteTranscripts.cast<String>();
    }

    plant
      ..caule = json['caule'] as String?
      ..folhaDescricao = json['folhaDescricao'] as String?
      ..florDescricao = json['florDescricao'] as String?
      ..frutoDescricao = json['frutoDescricao'] as String?
      ..sementeDescricao = json['sementeDescricao'] as String?;

    final morphology = _asStringDynamicMap(json['morphology']);
    if (morphology != null) {
      plant.raiz = morphology['root'] as String?;

      final stem = _asStringDynamicMap(morphology['stem']);
      if (stem != null) {
        plant.cauleTipoCasca = stem['type'] as String?;
        plant.cauleCor = stem['color'] as String?;
        plant.cauleTamanho = _parseMeasurementValue(stem['size'] as String?);
        plant.cauleTamanhoUnidade = _parseMeasurementUnit(
          stem['size'] as String?,
        );
        plant.cauleCircunferencia = _parseMeasurementValue(
          stem['circumference'] as String?,
        );
        plant.cauleCircunferenciaUnidade = _parseMeasurementUnit(
          stem['circumference'] as String?,
        );
        plant.cauleDescricaoSeiva = stem['sap'] as String?;
        plant.cauleTemSeiva = stem['sap'] != null;
      }

      final leaf = _asStringDynamicMap(morphology['leaf']);
      if (leaf != null) {
        plant.folhaBainha = leaf['bainha'] as String?;
        plant.folhaPeciolo = leaf['peciolo'] as String?;
        plant.folhaLamina = leaf['lamina'] as String?;
      }

      final flower = _asStringDynamicMap(morphology['flower']);
      if (flower != null) {
        plant.florInflorescencia = flower['inflorescence'] as String?;
        plant.florCor = flower['color'] as String?;
        plant.florTamanho = _parseMeasurementValue(flower['size'] as String?);
        plant.florTamanhoUnidade = _parseMeasurementUnit(
          flower['size'] as String?,
        );
      }

      final fruit = _asStringDynamicMap(morphology['fruit']);
      if (fruit != null) {
        plant.frutoCor = fruit['color'] as String?;
        plant.frutoFormato = fruit['format'] as String?;
        plant.frutoTamanho = _parseMeasurementValue(fruit['size'] as String?);
        plant.frutoTamanhoUnidade = _parseMeasurementUnit(
          fruit['size'] as String?,
        );
      }

      final seed = _asStringDynamicMap(morphology['seed']);
      if (seed != null) {
        plant.sementeFormato = seed['format'] as String?;
        plant.sementeCor = seed['color'] as String?;
        plant.sementeTamanho = _parseMeasurementValue(seed['size'] as String?);
        plant.sementeTamanhoUnidade = _parseMeasurementUnit(
          seed['size'] as String?,
        );
      }

      return;
    }

    plant
      ..raiz = json['raiz'] as String?
      ..cauleTipoCasca = json['cauleTipoCasca'] as String?
      ..cauleCor = json['cauleCor'] as String?
      ..cauleTamanho = (json['cauleTamanho'] as num?)?.toDouble()
      ..cauleTamanhoUnidade = json['cauleTamanhoUnidade'] as String?
      ..cauleCircunferencia = (json['cauleCircunferencia'] as num?)?.toDouble()
      ..cauleCircunferenciaUnidade =
          json['cauleCircunferenciaUnidade'] as String?
      ..cauleTemSeiva = json['cauleTemSeiva'] as bool? ?? false
      ..cauleDescricaoSeiva = json['cauleDescricaoSeiva'] as String?
      ..folhaBainha = json['folhaBainha'] as String?
      ..folhaPeciolo = json['folhaPeciolo'] as String?
      ..folhaLamina = json['folhaLamina'] as String?
      ..florInflorescencia = json['florInflorescencia'] as String?
      ..florCor = json['florCor'] as String?
      ..florTamanho = (json['florTamanho'] as num?)?.toDouble()
      ..florTamanhoUnidade = json['florTamanhoUnidade'] as String?
      ..frutoCor = json['frutoCor'] as String?
      ..frutoFormato = json['frutoFormato'] as String?
      ..frutoTamanho = (json['frutoTamanho'] as num?)?.toDouble()
      ..frutoTamanhoUnidade = json['frutoTamanhoUnidade'] as String?
      ..sementeCor = json['sementeCor'] as String?
      ..sementeFormato = json['sementeFormato'] as String?
      ..sementeTamanho = (json['sementeTamanho'] as num?)?.toDouble()
      ..sementeTamanhoUnidade = json['sementeTamanhoUnidade'] as String?;
  }

  /// Extracts the species epithet from either a flat string field or a
  /// populated Species object returned by the server (after `.populate('species')`).
  String? _extractSpeciesEpithet(Map<String, dynamic> json) {
    final raw = json['species'];
    if (raw == null) return null;
    if (raw is String) return raw;
    if (raw is Map) {
      // Populated Species document: { scientificName, genus, species (epithet), ... }
      return raw['species'] as String?;
    }
    return null;
  }

  String? _formatMeasurementWithUnit(double? value, String? unit) {
    if (value == null) return null;
    return '$value${unit ?? ''}';
  }

  Map<String, dynamic>? _asStringDynamicMap(dynamic value) {
    if (value is Map) {
      return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
    }
    return null;
  }

  double? _parseMeasurementValue(String? value) {
    if (value == null) return null;

    final match = RegExp(
      r'^\s*(-?\d+(?:[\.,]\d+)?)\s*(.*)\s*$',
    ).firstMatch(value);
    if (match == null) return null;

    return double.tryParse(match.group(1)!.replaceAll(',', '.'));
  }

  String? _parseMeasurementUnit(String? value) {
    if (value == null) return null;

    final match = RegExp(
      r'^\s*(-?\d+(?:[\.,]\d+)?)\s*(.*)\s*$',
    ).firstMatch(value);
    if (match == null) return null;

    final unit = match.group(2)?.trim();
    if (unit == null || unit.isEmpty) return null;

    return unit;
  }

  Future<void> _upsertSessionFromRemote(Map<String, dynamic> json) async {
    final isar = await IsarService.instance.isar;
    final uuid = json['uuid'] as String;

    var existing = await isar.collectionSessions
        .filter()
        .uuidEqualTo(uuid)
        .findFirst();

    if (existing != null &&
        existing.syncMetadata.syncStatus == SyncStatus.pending) {
      return;
    }

    final session = existing ?? CollectionSession();
    if (existing == null) {
      session.createdAt =
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now();
    }
    session
      ..uuid = uuid
      ..tripName = json['tripName'] as String? ?? ''
      ..startDate = DateTime.parse(
        json['startDate'] as String? ?? DateTime.now().toIso8601String(),
      )
      ..endDate = json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null
      ..location = json['location'] as String?
      ..shareCode = json['shareCode'] as String?
      ..notes = json['notes'] as String?
      ..isArchived = json['isArchived'] as bool? ?? false;

    final teamMembers = json['teamMembers'] as List?;
    if (teamMembers != null) {
      session.teamMembers = teamMembers.cast<String>();
    }

    final sharedWith = json['sharedWith'] as List?;
    if (sharedWith != null) {
      session.sharedWith = sharedWith.cast<String>();
    }

    final track = json['track'] as List?;
    if (track != null) {
      session.track = track.map((raw) {
        final point = raw as Map;
        return GpsPoint()
          ..latitude = (point['latitude'] as num?)?.toDouble() ?? 0
          ..longitude = (point['longitude'] as num?)?.toDouble() ?? 0
          ..altitude = (point['altitude'] as num?)?.toDouble()
          ..timestamp = DateTime.parse(
            point['timestamp'] as String? ?? DateTime.now().toIso8601String(),
          );
      }).toList();
    }

    session.syncMetadata
      ..syncStatus = SyncStatus.synced
      ..lastSyncedAt = DateTime.now()
      ..serverId = json['id'] as String?
      ..syncVersion =
          ((json['syncMetadata'] as Map?)?['syncVersion'] as num?)?.toInt() ??
          session.syncMetadata.syncVersion;

    await isar.writeTxn(() async {
      await isar.collectionSessions.put(session);
    });
  }
}
