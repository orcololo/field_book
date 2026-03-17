import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';

import '../../models/collection_session.dart';
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

  const SyncResult({
    this.pushed = 0,
    this.pulled = 0,
    this.conflicts = 0,
    this.errors = 0,
    this.errorMessages = const [],
  });

  SyncResult operator +(SyncResult other) => SyncResult(
        pushed: pushed + other.pushed,
        pulled: pulled + other.pulled,
        conflicts: conflicts + other.conflicts,
        errors: errors + other.errors,
        errorMessages: [...errorMessages, ...other.errorMessages],
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
  })  : _api = api,
        _mediaUpload = mediaUpload,
        _connectivity = connectivity ?? Connectivity();

  /// Run a full sync cycle: upload media → push changes → pull remote.
  Future<SyncResult> sync({String? deviceId}) async {
    if (_isSyncing) return const SyncResult();

    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      _log.d('Offline — skipping sync');
      return const SyncResult();
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
    for (final plant in pendingPlants) {
      await _uploadPlantMedia(plant);
    }

    // Build push payload
    final registries = pendingPlants.map(_plantToSyncJson).toList();
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
          await _markPlantSynced(pendingPlants[i], result);
        } else if (status == 'conflict') {
          conflicts++;
          await _markPlantConflict(pendingPlants[i], result);
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
      return SyncResult(pulled: pulled, errors: 1, errorMessages: [e.toString()]);
    }

    return SyncResult(pulled: pulled);
  }

  // ── Media Upload ──────────────────────────────────────

  Future<void> _uploadPlantMedia(PlantRecord plant) async {
    final updatedPhotoPaths = <String>[];
    for (final path in plant.photoPaths) {
      if (path.startsWith('http')) {
        updatedPhotoPaths.add(path);
        continue;
      }
      final file = File(path);
      if (!file.existsSync()) {
        updatedPhotoPaths.add(path);
        continue;
      }
      try {
        final result = await _mediaUpload.uploadImage(file);
        updatedPhotoPaths.add(result.originalUrl);
      } catch (e) {
        _log.w('Failed to upload image $path: $e');
        updatedPhotoPaths.add(path); // Keep local path
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
        updatedAudioPaths.add(path);
        continue;
      }
      try {
        final result = await _mediaUpload.uploadAudio(file);
        updatedAudioPaths.add(result.originalUrl);
      } catch (e) {
        _log.w('Failed to upload audio $path: $e');
        updatedAudioPaths.add(path);
      }
    }
    plant.audioNotePaths = updatedAudioPaths;
  }

  // ── JSON Mapping ──────────────────────────────────────

  Map<String, dynamic> _plantToSyncJson(PlantRecord plant) {
    return {
      'uuid': plant.uuid,
      'registryIdentifier': plant.registryIdentifier,
      'scientificName': plant.scientificName,
      'commonName': plant.commonName,
      'family': plant.family,
      'genus': plant.genus,
      'species': plant.species,
      'habitat': plant.habitat,
      'category': plant.category.name,
      'dateCollected': plant.dateCollected.toIso8601String(),
      'latitude': plant.latitude,
      'longitude': plant.longitude,
      'notes': plant.notes,
      'isDraft': plant.isDraft,
      'sessionId': plant.sessionId,
      'deviceId': plant.deviceId,
      'contributorName': plant.contributorName,
      'photoPaths': plant.photoPaths,
      'audioNotePaths': plant.audioNotePaths,
      'audioTranscripts': plant.audioTranscripts,
      'measurements': plant.measurements
          .map((m) => {'label': m.label, 'value': m.value, 'unit': m.unit})
          .toList(),
      'photoMetadata': plant.photoMetadata
          .map((p) => {
                'exifDataJson': p.exifDataJson,
                'dateTaken': p.dateTaken?.toIso8601String(),
                'latitude': p.latitude,
                'longitude': p.longitude,
                'fileSize': p.fileSize,
              })
          .toList(),
      // Morphology
      'raiz': plant.raiz,
      'caule': plant.caule,
      'cauleTipoCasca': plant.cauleTipoCasca,
      'cauleCor': plant.cauleCor,
      'cauleTamanho': plant.cauleTamanho,
      'cauleTamanhoUnidade': plant.cauleTamanhoUnidade,
      'cauleCircunferencia': plant.cauleCircunferencia,
      'cauleCircunferenciaUnidade': plant.cauleCircunferenciaUnidade,
      'cauleTemSeiva': plant.cauleTemSeiva,
      'cauleDescricaoSeiva': plant.cauleDescricaoSeiva,
      'folhaDescricao': plant.folhaDescricao,
      'folhaBainha': plant.folhaBainha,
      'folhaPeciolo': plant.folhaPeciolo,
      'folhaLamina': plant.folhaLamina,
      'florDescricao': plant.florDescricao,
      'florInflorescencia': plant.florInflorescencia,
      'florCor': plant.florCor,
      'florTamanho': plant.florTamanho,
      'florTamanhoUnidade': plant.florTamanhoUnidade,
      'frutoDescricao': plant.frutoDescricao,
      'frutoCor': plant.frutoCor,
      'frutoFormato': plant.frutoFormato,
      'frutoTamanho': plant.frutoTamanho,
      'frutoTamanhoUnidade': plant.frutoTamanhoUnidade,
      'sementeDescricao': plant.sementeDescricao,
      'sementeCor': plant.sementeCor,
      'sementeFormato': plant.sementeFormato,
      'sementeTamanho': plant.sementeTamanho,
      'sementeTamanhoUnidade': plant.sementeTamanhoUnidade,
      // Sync version
      'syncVersion': plant.syncMetadata.lastPushedHash != null ? 1 : 0,
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
      'notes': session.notes,
      'isArchived': session.isArchived,
      'localModifiedAt': session.createdAt.toIso8601String(),
      'syncVersion': 0,
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
      ..serverId = result['serverId'] as String?;

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
      ..serverId = result['serverId'] as String?;

    await isar.writeTxn(() async {
      await isar.collectionSessions.put(session);
    });
  }

  // ── Remote → Local Upsert ────────────────────────────

  Future<void> _upsertPlantFromRemote(Map<String, dynamic> json) async {
    final isar = await IsarService.instance.isar;
    final uuid = json['uuid'] as String;

    var existing = await isar.plantRecords.filter().uuidEqualTo(uuid).findFirst();

    // If local copy is newer and pending, skip (will push on next cycle)
    if (existing != null &&
        existing.syncMetadata.syncStatus == SyncStatus.pending) {
      return;
    }

    final plant = existing ?? PlantRecord();
    _applyRemoteDataToPlant(plant, json);
    plant.syncMetadata
      ..syncStatus = SyncStatus.synced
      ..lastSyncedAt = DateTime.now()
      ..serverId = json['_id'] as String?;

    await isar.writeTxn(() async {
      await isar.plantRecords.put(plant);
    });
  }

  void _applyRemoteDataToPlant(PlantRecord plant, Map<String, dynamic> json) {
    plant
      ..uuid = json['uuid'] as String
      ..scientificName = json['scientificName'] as String? ?? ''
      ..commonName = json['commonName'] as String? ?? ''
      ..family = json['family'] as String?
      ..genus = json['genus'] as String?
      ..species = json['species'] as String?
      ..habitat = json['habitat'] as String?
      ..registryIdentifier = json['registryIdentifier'] as String?
      ..notes = json['notes'] as String?
      ..isDraft = json['isDraft'] as bool? ?? true
      ..sessionId = json['sessionId'] as String?
      ..deviceId = json['deviceId'] as String? ?? ''
      ..contributorName = json['contributorName'] as String?
      ..dateCollected = DateTime.parse(
        json['dateCollected'] as String? ?? DateTime.now().toIso8601String(),
      )
      ..latitude = (json['latitude'] as num?)?.toDouble()
      ..longitude = (json['longitude'] as num?)?.toDouble()
      ..updatedAt = DateTime.now()
      ..createdAt = plant.createdAt;

    plant.updateFtsFields();

    // Photos & audio
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

    // Morphology
    plant
      ..raiz = json['raiz'] as String?
      ..caule = json['caule'] as String?
      ..cauleTipoCasca = json['cauleTipoCasca'] as String?
      ..cauleCor = json['cauleCor'] as String?
      ..cauleTamanho = (json['cauleTamanho'] as num?)?.toDouble()
      ..cauleTamanhoUnidade = json['cauleTamanhoUnidade'] as String?
      ..cauleCircunferencia = (json['cauleCircunferencia'] as num?)?.toDouble()
      ..cauleCircunferenciaUnidade = json['cauleCircunferenciaUnidade'] as String?
      ..cauleTemSeiva = json['cauleTemSeiva'] as bool? ?? false
      ..cauleDescricaoSeiva = json['cauleDescricaoSeiva'] as String?
      ..folhaDescricao = json['folhaDescricao'] as String?
      ..folhaBainha = json['folhaBainha'] as String?
      ..folhaPeciolo = json['folhaPeciolo'] as String?
      ..folhaLamina = json['folhaLamina'] as String?
      ..florDescricao = json['florDescricao'] as String?
      ..florInflorescencia = json['florInflorescencia'] as String?
      ..florCor = json['florCor'] as String?
      ..florTamanho = (json['florTamanho'] as num?)?.toDouble()
      ..florTamanhoUnidade = json['florTamanhoUnidade'] as String?
      ..frutoDescricao = json['frutoDescricao'] as String?
      ..frutoCor = json['frutoCor'] as String?
      ..frutoFormato = json['frutoFormato'] as String?
      ..frutoTamanho = (json['frutoTamanho'] as num?)?.toDouble()
      ..frutoTamanhoUnidade = json['frutoTamanhoUnidade'] as String?
      ..sementeDescricao = json['sementeDescricao'] as String?
      ..sementeCor = json['sementeCor'] as String?
      ..sementeFormato = json['sementeFormato'] as String?
      ..sementeTamanho = (json['sementeTamanho'] as num?)?.toDouble()
      ..sementeTamanhoUnidade = json['sementeTamanhoUnidade'] as String?;
  }

  Future<void> _upsertSessionFromRemote(Map<String, dynamic> json) async {
    final isar = await IsarService.instance.isar;
    final uuid = json['uuid'] as String;

    var existing =
        await isar.collectionSessions.filter().uuidEqualTo(uuid).findFirst();

    if (existing != null &&
        existing.syncMetadata.syncStatus == SyncStatus.pending) {
      return;
    }

    final session = existing ?? CollectionSession();
    session
      ..uuid = uuid
      ..tripName = json['tripName'] as String? ?? ''
      ..startDate = DateTime.parse(
        json['startDate'] as String? ?? DateTime.now().toIso8601String(),
      )
      ..endDate =
          json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null
      ..location = json['location'] as String?
      ..notes = json['notes'] as String?
      ..isArchived = json['isArchived'] as bool? ?? false
      ..createdAt = session.createdAt;

    final teamMembers = json['teamMembers'] as List?;
    if (teamMembers != null) {
      session.teamMembers = teamMembers.cast<String>();
    }

    session.syncMetadata
      ..syncStatus = SyncStatus.synced
      ..lastSyncedAt = DateTime.now()
      ..serverId = json['_id'] as String?;

    await isar.writeTxn(() async {
      await isar.collectionSessions.put(session);
    });
  }
}
