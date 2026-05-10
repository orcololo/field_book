import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/determination.dart';
import '../../models/plant_record.dart';
import '../../models/measurement.dart';
import '../../models/photo_metadata.dart';
import '../../models/plant_category.dart';
import '../../models/collection_session.dart';
import '../../models/gps_point.dart';
import '../repositories/plant_repository.dart';
import '../repositories/session_repository.dart';

enum ExportFormat { json, csv, darwinCore }

class ExportImportService {
  final PlantRepository _plantRepo;
  final SessionRepository _sessionRepo;

  ExportImportService(this._plantRepo, this._sessionRepo);

  // Export plants to JSON
  Future<String> exportToJson({
    List<PlantRecord>? plants,
    bool includeSessions = false,
  }) async {
    plants ??= await _plantRepo.getPaginated(limit: 100000);

    final List<Map<String, dynamic>> plantsJson = plants.map((plant) {
      return {
        'uuid': plant.uuid,
        'scientificName': plant.scientificName,
        'commonName': plant.commonName,
        'family': plant.family,
        'genus': plant.genus,
        'species': plant.species,
        'habitat': plant.habitat,
        'dateCollected': plant.dateCollected.toIso8601String(),
        'latitude': plant.latitude,
        'longitude': plant.longitude,
        'locality': plant.locality,
        'municipality': plant.municipality,
        'state': plant.state,
        'country': plant.country,
        'altitude': plant.altitude,
        'temperature': plant.temperature,
        'humidity': plant.humidity,
        'weatherCondition': plant.weatherCondition,
        'weatherNotes': plant.weatherNotes,
        'moonPhase': plant.moonPhase,
        'windSpeed': plant.windSpeed,
        'category': plant.category.name,
        'determinations': plant.determinations
            .map(
              (d) => {
                'determinedBy': d.determinedBy,
                'determinedAt': d.determinedAt.toIso8601String(),
                'scientificName': d.scientificName,
                'family': d.family,
                'notes': d.notes,
                'basis': d.basis,
              },
            )
            .toList(),
        'measurements': plant.measurements
            .map((m) => {'label': m.label, 'value': m.value, 'unit': m.unit})
            .toList(),
        'photoPaths': plant.photoPaths,
        'photoMetadata': plant.photoMetadata
            .map(
              (pm) => {
                'exifDataJson': pm.exifDataJson,
                'dateTaken': pm.dateTaken?.toIso8601String(),
                'latitude': pm.latitude,
                'longitude': pm.longitude,
                'fileSize': pm.fileSize,
              },
            )
            .toList(),
        'audioNotePaths': plant.audioNotePaths,
        'audioTranscripts': plant.audioTranscripts,
        'duplicateOf': plant.duplicateOf,
        'duplicateUuids': plant.duplicateUuids,
        'notes': plant.notes,
        'iNaturalistId': plant.iNaturalistId,
        'iNaturalistSyncedAt': plant.iNaturalistSyncedAt?.toIso8601String(),
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
        'isDraft': plant.isDraft,
        'sessionId': plant.sessionId,
        'deviceId': plant.deviceId,
        'contributorName': plant.contributorName,
        'createdAt': plant.createdAt.toIso8601String(),
        'updatedAt': plant.updatedAt.toIso8601String(),
      };
    }).toList();

    Map<String, dynamic> exportData = {
      'version': '1.0',
      'exportDate': DateTime.now().toIso8601String(),
      'plantCount': plants.length,
      'plants': plantsJson,
    };

    if (includeSessions) {
      final sessions = await _sessionRepo.getAll();
      exportData['sessions'] = sessions
          .map(
            (s) => {
              'uuid': s.uuid,
              'tripName': s.tripName,
              'location': s.location,
              'startDate': s.startDate.toIso8601String(),
              'endDate': s.endDate?.toIso8601String(),
              'teamMembers': s.teamMembers,
              'notes': s.notes,
              'shareCode': s.shareCode,
              'track': s.track
                  .map(
                    (point) => {
                      'latitude': point.latitude,
                      'longitude': point.longitude,
                      'altitude': point.altitude,
                      'timestamp': point.timestamp.toIso8601String(),
                    },
                  )
                  .toList(),
              'trackGeoJson': _buildTrackGeoJson(s),
              'isArchived': s.isArchived,
              'createdAt': s.createdAt.toIso8601String(),
            },
          )
          .toList();
    }

    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  // Export plants to CSV
  Future<String> exportToCsv({List<PlantRecord>? plants}) async {
    plants ??= await _plantRepo.getPaginated(limit: 100000);

    final buffer = StringBuffer();

    // CSV Header
    buffer.writeln(
      'UUID,Nome Científico,Nome Popular,Família,Gênero,Espécie,'
      'Data Coleta,Latitude,Longitude,Localidade,Município,Estado,País,Categoria,Habitat,'
      'Fotos,Notas Áudio,Observações,Raiz,Caule,Caule Tipo Casca,Caule Cor,Caule Tamanho,Caule Tamanho Unid,Caule Circunf,Caule Circunf Unid,Caule Seiva,Caule Descrição Seiva,Folha Descrição,Folha Bainha,Folha Pecíolo,Folha Lâmina,'
      'Flor Descrição,Flor Inflorescência,Flor Cor,Flor Tamanho,Flor Tamanho Unid,'
      'Fruto Descrição,Fruto Cor,Fruto Formato,Fruto Tamanho,Fruto Tamanho Unid,'
      'Semente Descrição,Semente Cor,Semente Formato,Semente Tamanho,Semente Tamanho Unid,'
      'Altitude,Temperatura,Umidade,Condição Climática,Notas Climáticas,Fase Lunar,Velocidade Vento,'
      'Rascunho,Criado em,Atualizado em',
    );

    // CSV Rows
    for (final plant in plants) {
      buffer.writeln(
        [
          _escapeCsv(plant.uuid),
          _escapeCsv(plant.scientificName),
          _escapeCsv(plant.commonName),
          _escapeCsv(plant.family ?? ''),
          _escapeCsv(plant.genus ?? ''),
          _escapeCsv(plant.species ?? ''),
          _formatDate(plant.dateCollected),
          plant.latitude?.toStringAsFixed(6) ?? '',
          plant.longitude?.toStringAsFixed(6) ?? '',
          _escapeCsv(plant.locality ?? ''),
          _escapeCsv(plant.municipality ?? ''),
          _escapeCsv(plant.state ?? ''),
          _escapeCsv(plant.country ?? ''),
          _getCategoryName(plant.category),
          _escapeCsv(plant.habitat ?? ''),
          plant.photoPaths.length.toString(),
          plant.audioNotePaths.length.toString(),
          _escapeCsv(plant.notes ?? ''),
          _escapeCsv(plant.raiz ?? ''),
          _escapeCsv(plant.caule ?? ''),
          _escapeCsv(plant.cauleTipoCasca ?? ''),
          _escapeCsv(plant.cauleCor ?? ''),
          plant.cauleTamanho?.toString() ?? '',
          _escapeCsv(plant.cauleTamanhoUnidade ?? ''),
          plant.cauleCircunferencia?.toString() ?? '',
          _escapeCsv(plant.cauleCircunferenciaUnidade ?? ''),
          plant.cauleTemSeiva ? 'Sim' : 'Não',
          _escapeCsv(plant.cauleDescricaoSeiva ?? ''),
          _escapeCsv(plant.folhaDescricao ?? ''),
          _escapeCsv(plant.folhaBainha ?? ''),
          _escapeCsv(plant.folhaPeciolo ?? ''),
          _escapeCsv(plant.folhaLamina ?? ''),
          _escapeCsv(plant.florDescricao ?? ''),
          _escapeCsv(plant.florInflorescencia ?? ''),
          _escapeCsv(plant.florCor ?? ''),
          plant.florTamanho?.toString() ?? '',
          _escapeCsv(plant.florTamanhoUnidade ?? ''),
          _escapeCsv(plant.frutoDescricao ?? ''),
          _escapeCsv(plant.frutoCor ?? ''),
          _escapeCsv(plant.frutoFormato ?? ''),
          plant.frutoTamanho?.toString() ?? '',
          _escapeCsv(plant.frutoTamanhoUnidade ?? ''),
          _escapeCsv(plant.sementeDescricao ?? ''),
          _escapeCsv(plant.sementeCor ?? ''),
          _escapeCsv(plant.sementeFormato ?? ''),
          plant.sementeTamanho?.toString() ?? '',
          _escapeCsv(plant.sementeTamanhoUnidade ?? ''),
          plant.altitude?.toString() ?? '',
          plant.temperature?.toString() ?? '',
          plant.humidity?.toString() ?? '',
          _escapeCsv(plant.weatherCondition ?? ''),
          _escapeCsv(plant.weatherNotes ?? ''),
          _escapeCsv(plant.moonPhase ?? ''),
          plant.windSpeed?.toString() ?? '',
          plant.isDraft ? 'Sim' : 'Não',
          _formatDate(plant.createdAt),
          _formatDate(plant.updatedAt),
        ].join(','),
      );
    }

    return buffer.toString();
  }

  // Export to Darwin Core format (standard for biodiversity data)
  Future<String> exportToDarwinCore({List<PlantRecord>? plants}) async {
    plants ??= await _plantRepo.getPaginated(limit: 100000);

    final buffer = StringBuffer();

    // Darwin Core Standard headers
    buffer.writeln(
      'occurrenceID,catalogNumber,scientificName,vernacularName,family,genus,'
      'specificEpithet,identificationQualifier,eventDate,decimalLatitude,decimalLongitude,'
      'habitat,substrate,verbatimLocality,associatedTaxa,'
      'basisOfRecord,recordedBy,recordNumber,individualCount,'
      'minimumElevationInMeters,phenology,collectionCode,'
      'eventRemarks,occurrenceRemarks,identificationRemarks,'
      'modified',
    );

    for (final plant in plants) {
      buffer.writeln(
        [
          _escapeCsv(plant.uuid),
          _escapeCsv(plant.registryIdentifier ?? ''),
          _escapeCsv(plant.scientificName),
          _escapeCsv(plant.commonName),
          _escapeCsv(plant.family ?? ''),
          _escapeCsv(plant.genus ?? ''),
          _escapeCsv(plant.species ?? ''),
          _escapeCsv(plant.determinationQualifier ?? ''),
          _formatDateIso(plant.dateCollected),
          plant.latitude?.toStringAsFixed(6) ?? '',
          plant.longitude?.toStringAsFixed(6) ?? '',
          _escapeCsv(plant.habitat ?? ''),
          _escapeCsv(plant.substrate ?? ''),
          _escapeCsv(plant.vegetationType ?? ''),
          _escapeCsv(plant.associatedTaxa ?? ''),
          'HumanObservation',
          _escapeCsv(plant.contributorName ?? ''),
          _escapeCsv(plant.collectorNumber ?? ''),
          plant.numberOfIndividuals?.toString() ?? '',
          plant.altitude?.toString() ?? '',
          _escapeCsv(plant.phenologicalState?.name ?? ''),
          _escapeCsv(plant.topography ?? ''),
          '', // eventRemarks
          _escapeCsv(plant.notes ?? ''),
          _escapeCsv(_buildIdentificationRemarks(plant)),
          _formatDateIso(plant.updatedAt),
        ].join(','),
      );
    }

    return buffer.toString();
  }

  // Save export to file and share
  Future<void> saveAndShareExport(
    String content,
    String filename,
    String mimeType,
  ) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsString(content);

    await Share.shareXFiles([
      XFile(file.path, mimeType: mimeType),
    ], subject: 'Exportação Folium');
  }

  // Import plants from JSON
  Future<ImportResult> importFromJson(String jsonContent) async {
    try {
      final data = json.decode(jsonContent) as Map<String, dynamic>;
      final plantsData = data['plants'] as List<dynamic>;

      int imported = 0;
      int updated = 0;
      int skipped = 0;
      final List<String> errors = [];

      for (final plantData in plantsData) {
        try {
          final uuid = plantData['uuid'] as String;
          final existing = await _plantRepo.getByUuid(uuid);

          final plant = PlantRecord()
            ..uuid = uuid
            ..scientificName = plantData['scientificName'] as String
            ..commonName = plantData['commonName'] as String? ?? ''
            ..family = plantData['family'] as String?
            ..genus = plantData['genus'] as String?
            ..species = plantData['species'] as String?
            ..habitat = plantData['habitat'] as String?
            ..dateCollected = DateTime.parse(
              plantData['dateCollected'] as String,
            )
            ..latitude = (plantData['latitude'] as num?)?.toDouble()
            ..longitude = (plantData['longitude'] as num?)?.toDouble()
            ..locality = plantData['locality'] as String?
            ..municipality = plantData['municipality'] as String?
            ..state = plantData['state'] as String?
            ..country = plantData['country'] as String?
            ..altitude = (plantData['altitude'] as num?)?.toDouble()
            ..temperature = (plantData['temperature'] as num?)?.toDouble()
            ..humidity = (plantData['humidity'] as num?)?.toDouble()
            ..weatherCondition = plantData['weatherCondition'] as String?
            ..weatherNotes = plantData['weatherNotes'] as String?
            ..moonPhase = plantData['moonPhase'] as String?
            ..windSpeed = (plantData['windSpeed'] as num?)?.toDouble()
            ..category = PlantCategory.values.firstWhere(
              (c) => c.name == plantData['category'],
              orElse: () => PlantCategory.herbs,
            )
            ..determinations =
                (plantData['determinations'] as List<dynamic>?)
                    ?.map(
                      (d) => Determination()
                        ..determinedBy = d['determinedBy'] as String? ?? ''
                        ..determinedAt = DateTime.parse(
                          d['determinedAt'] as String? ??
                              DateTime.now().toIso8601String(),
                        )
                        ..scientificName = d['scientificName'] as String? ?? ''
                        ..family = d['family'] as String?
                        ..notes = d['notes'] as String?
                        ..basis = d['basis'] as String?,
                    )
                    .toList() ??
                []
            ..measurements =
                (plantData['measurements'] as List<dynamic>?)
                    ?.map(
                      (m) => Measurement()
                        ..label = m['label'] as String
                        ..value = (m['value'] as num).toDouble()
                        ..unit = m['unit'] as String,
                    )
                    .toList() ??
                []
            ..photoPaths = List<String>.from(
              plantData['photoPaths'] as List<dynamic>? ?? [],
            )
            ..photoMetadata =
                (plantData['photoMetadata'] as List<dynamic>?)
                    ?.map(
                      (pm) => PhotoMetadata()
                        ..exifDataJson = pm['exifDataJson'] as String? ?? '{}'
                        ..dateTaken = pm['dateTaken'] != null
                            ? DateTime.parse(pm['dateTaken'] as String)
                            : null
                        ..latitude = (pm['latitude'] as num?)?.toDouble()
                        ..longitude = (pm['longitude'] as num?)?.toDouble()
                        ..fileSize = pm['fileSize'] as int? ?? 0,
                    )
                    .toList() ??
                []
            ..audioNotePaths = List<String>.from(
              plantData['audioNotePaths'] as List<dynamic>? ?? [],
            )
            ..audioTranscripts = List<String>.from(
              plantData['audioTranscripts'] as List<dynamic>? ?? [],
            )
            ..duplicateOf = plantData['duplicateOf'] as String?
            ..duplicateUuids = List<String>.from(
              plantData['duplicateUuids'] as List<dynamic>? ?? [],
            )
            ..notes = plantData['notes'] as String?
            ..iNaturalistId = plantData['iNaturalistId'] as String?
            ..iNaturalistSyncedAt = plantData['iNaturalistSyncedAt'] != null
                ? DateTime.parse(plantData['iNaturalistSyncedAt'] as String)
                : null
            ..raiz = plantData['raiz'] as String?
            ..caule = plantData['caule'] as String?
            ..cauleTipoCasca = plantData['cauleTipoCasca'] as String?
            ..cauleCor = plantData['cauleCor'] as String?
            ..cauleTamanho = (plantData['cauleTamanho'] as num?)?.toDouble()
            ..cauleTamanhoUnidade = plantData['cauleTamanhoUnidade'] as String?
            ..cauleCircunferencia = (plantData['cauleCircunferencia'] as num?)
                ?.toDouble()
            ..cauleCircunferenciaUnidade =
                plantData['cauleCircunferenciaUnidade'] as String?
            ..cauleTemSeiva = plantData['cauleTemSeiva'] as bool? ?? false
            ..cauleDescricaoSeiva = plantData['cauleDescricaoSeiva'] as String?
            ..folhaDescricao = plantData['folhaDescricao'] as String?
            ..folhaBainha = plantData['folhaBainha'] as String?
            ..folhaPeciolo = plantData['folhaPeciolo'] as String?
            ..folhaLamina = plantData['folhaLamina'] as String?
            ..florDescricao = plantData['florDescricao'] as String?
            ..florInflorescencia = plantData['florInflorescencia'] as String?
            ..florCor = plantData['florCor'] as String?
            ..florTamanho = (plantData['florTamanho'] as num?)?.toDouble()
            ..florTamanhoUnidade = plantData['florTamanhoUnidade'] as String?
            ..frutoDescricao = plantData['frutoDescricao'] as String?
            ..frutoCor = plantData['frutoCor'] as String?
            ..frutoFormato = plantData['frutoFormato'] as String?
            ..frutoTamanho = (plantData['frutoTamanho'] as num?)?.toDouble()
            ..frutoTamanhoUnidade = plantData['frutoTamanhoUnidade'] as String?
            ..sementeDescricao = plantData['sementeDescricao'] as String?
            ..sementeCor = plantData['sementeCor'] as String?
            ..sementeFormato = plantData['sementeFormato'] as String?
            ..sementeTamanho = (plantData['sementeTamanho'] as num?)?.toDouble()
            ..sementeTamanhoUnidade =
                plantData['sementeTamanhoUnidade'] as String?
            ..isDraft = plantData['isDraft'] as bool? ?? true
            ..sessionId = plantData['sessionId'] as String?
            ..deviceId = plantData['deviceId'] as String
            ..contributorName = plantData['contributorName'] as String?
            ..createdAt = DateTime.parse(plantData['createdAt'] as String)
            ..updatedAt = DateTime.parse(plantData['updatedAt'] as String);

          plant.applyLatestDetermination();
          plant.updateFtsFields();

          if (existing != null) {
            // Update existing record
            plant.id = existing.id;
            await _plantRepo.save(plant);
            updated++;
          } else {
            // Create new record
            await _plantRepo.save(plant);
            imported++;
          }
        } catch (e) {
          errors.add('Erro ao importar planta: $e');
          skipped++;
        }
      }

      return ImportResult(
        imported: imported,
        updated: updated,
        skipped: skipped,
        errors: errors,
      );
    } catch (e) {
      return ImportResult(
        imported: 0,
        updated: 0,
        skipped: 0,
        errors: ['Erro ao processar arquivo: $e'],
      );
    }
  }

  // Export to JSON string (for cloud backup)
  Future<String> exportToJsonString({bool includeSessions = true}) async {
    return exportToJson(includeSessions: includeSessions);
  }

  // Import from JSON string with session support (for cloud backup)
  Future<ImportResult> importFromJsonString(String jsonContent) async {
    final result = await importFromJson(jsonContent);

    // Also import sessions if present
    try {
      final data = json.decode(jsonContent) as Map<String, dynamic>;
      if (data.containsKey('sessions')) {
        final sessionsData = data['sessions'] as List<dynamic>;
        for (final sessionData in sessionsData) {
          try {
            final uuid = sessionData['uuid'] as String;
            final existing = await _sessionRepo.getByUuid(uuid);

            final session = CollectionSession()
              ..uuid = uuid
              ..tripName = sessionData['tripName'] as String
              ..location = sessionData['location'] as String?
              ..startDate = DateTime.parse(sessionData['startDate'] as String)
              ..endDate = sessionData['endDate'] != null
                  ? DateTime.parse(sessionData['endDate'] as String)
                  : null
              ..teamMembers = List<String>.from(
                sessionData['teamMembers'] as List<dynamic>? ?? [],
              )
              ..notes = sessionData['notes'] as String?
              ..shareCode = sessionData['shareCode'] as String?
              ..track =
                  (sessionData['track'] as List<dynamic>?)
                      ?.map(
                        (point) => GpsPoint()
                          ..latitude =
                              (point['latitude'] as num?)?.toDouble() ?? 0
                          ..longitude =
                              (point['longitude'] as num?)?.toDouble() ?? 0
                          ..altitude = (point['altitude'] as num?)?.toDouble()
                          ..timestamp = DateTime.parse(
                            point['timestamp'] as String? ??
                                DateTime.now().toIso8601String(),
                          ),
                      )
                      .toList() ??
                  []
              ..isArchived = sessionData['isArchived'] as bool? ?? false
              ..createdAt = DateTime.parse(sessionData['createdAt'] as String);

            if (existing != null) {
              session.id = existing.id;
            }
            await _sessionRepo.save(session);
          } catch (_) {
            // Skip invalid sessions silently
          }
        }
      }
    } catch (_) {
      // Session import is best-effort
    }

    return result;
  }

  // Pick and import file
  Future<ImportResult?> pickAndImportFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      // Use importFromJsonString so that session data embedded in the
      // backup file is also restored (not just plant records).
      return await importFromJsonString(content);
    }

    return null;
  }

  // Helper methods
  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatDateIso(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  Map<String, dynamic>? _buildTrackGeoJson(CollectionSession session) {
    if (session.track.isEmpty) {
      return null;
    }

    return {
      'type': 'LineString',
      'coordinates': session.track
          .map(
            (point) => [
              point.longitude,
              point.latitude,
              if (point.altitude != null) point.altitude,
            ],
          )
          .toList(),
    };
  }

  String _buildIdentificationRemarks(PlantRecord plant) {
    if (plant.determinations.isEmpty) {
      return '';
    }

    final entries = [...plant.determinations]
      ..sort((a, b) => a.determinedAt.compareTo(b.determinedAt));

    return entries
        .map((determination) {
          final date = _formatDateIso(determination.determinedAt);
          final family = (determination.family?.isNotEmpty ?? false)
              ? ' [${determination.family}]'
              : '';
          final by = determination.determinedBy.isNotEmpty
              ? ' by ${determination.determinedBy}'
              : '';
          final basis = (determination.basis?.isNotEmpty ?? false)
              ? ' (${determination.basis})'
              : '';
          final notes = (determination.notes?.isNotEmpty ?? false)
              ? ': ${determination.notes}'
              : '';
          return '$date - ${determination.scientificName}$family$by$basis$notes';
        })
        .join(' | ');
  }

  String _getCategoryName(PlantCategory category) {
    switch (category) {
      case PlantCategory.trees:
        return 'Árvores';
      case PlantCategory.shrubs:
        return 'Arbustos';
      case PlantCategory.herbs:
        return 'Ervas';
      case PlantCategory.vines:
        return 'Trepadeiras';
      case PlantCategory.ferns:
        return 'Samambaias';
      case PlantCategory.grasses:
        return 'Gramíneas';
      case PlantCategory.cacti:
        return 'Cactos';
      case PlantCategory.aquatic:
        return 'Aquáticas';
    }
  }
}

class ImportResult {
  final int imported;
  final int updated;
  final int skipped;
  final List<String> errors;

  ImportResult({
    required this.imported,
    required this.updated,
    required this.skipped,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;
  int get total => imported + updated;
}
