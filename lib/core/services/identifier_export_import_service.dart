import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/settings.dart';
import '../repositories/plant_repository.dart';
import '../database/isar_service.dart';

enum IdentifierExportFormat { json, csv, xlsx }

class IdentifierExportImportService {
  static final _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final PlantRepository _plantRepo;

  IdentifierExportImportService(this._plantRepo);

  // Max allowed length for imported cell values
  static const _maxCellLength = 256;

  // Pattern for valid UUID (v4)
  static final _uuidPattern = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  // Pattern for valid registry identifier (initials + number, e.g. RC000001)
  static final _identifierPattern = RegExp(r'^[A-Z]{2,5}\d{1,6}$');

  /// Validates and sanitizes a cell value from CSV/Excel import.
  /// Returns null if the value is malformed or potentially dangerous.
  static String? _sanitizeCell(String? raw) {
    if (raw == null) return null;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.length > _maxCellLength) return null;

    // Block formula injection (common in CSV/Excel attacks)
    if (trimmed.startsWith('=') ||
        trimmed.startsWith('+') ||
        trimmed.startsWith('-') ||
        trimmed.startsWith('@') ||
        trimmed.startsWith('\t') ||
        trimmed.startsWith('\r') ||
        trimmed.startsWith('\n')) {
      return null;
    }

    // Block null bytes and other control characters
    if (trimmed.codeUnits.any((c) => c < 32 && c != 9 && c != 10 && c != 13)) {
      return null;
    }

    return trimmed;
  }

  /// Validates that a string is a valid UUID
  static bool _isValidUuid(String value) => _uuidPattern.hasMatch(value);

  /// Validates that a string is a valid registry identifier
  static bool _isValidIdentifier(String value) =>
      _identifierPattern.hasMatch(value);

  /// Export identifiers to JSON format
  Future<File> exportToJson() async {
    final settings = await _getSettings();
    final plants = await _plantRepo.getPaginated(limit: 100000);
    
    // Filter only plants with identifiers
    final plantsWithIdentifiers = plants
        .where((p) => p.registryIdentifier != null)
        .toList();

    final exportData = {
      'version': '1.0',
      'exportDate': DateTime.now().toIso8601String(),
      'identifierConfig': {
        'userInitials': settings.userInitials,
        'lastRegistryNumber': settings.lastRegistryNumber,
        'autoGenerate': settings.autoGenerateIdentifier,
      },
      'assignedIdentifiers': plantsWithIdentifiers.map((plant) => {
        'plantUuid': plant.uuid,
        'identifier': plant.registryIdentifier,
        'scientificName': plant.scientificName,
        'dateCollected': plant.dateCollected.toIso8601String(),
      }).toList(),
    };

    final jsonString = JsonEncoder.withIndent('  ').convert(exportData);
    
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/folium_identifiers_$timestamp.json');
    
    await file.writeAsString(jsonString);
    return file;
  }

  /// Export identifiers to CSV format
  Future<File> exportToCsv() async {
    final settings = await _getSettings();
    final plants = await _plantRepo.getPaginated(limit: 100000);
    
    // Filter only plants with identifiers
    final plantsWithIdentifiers = plants
        .where((p) => p.registryIdentifier != null)
        .toList();

    // CSV headers
    final List<List<dynamic>> rows = [
      ['Plant UUID', 'Identifier', 'Scientific Name', 'Common Name', 'Date Collected'],
    ];

    // Add data rows
    for (final plant in plantsWithIdentifiers) {
      rows.add([
        plant.uuid,
        plant.registryIdentifier,
        plant.scientificName,
        plant.commonName,
        plant.dateCollected.toIso8601String(),
      ]);
    }

    // Add config as comments at the end
    rows.add([]);
    rows.add(['# Configuration']);
    rows.add(['User Initials', settings.userInitials]);
    rows.add(['Last Registry Number', settings.lastRegistryNumber]);
    rows.add(['Auto Generate', settings.autoGenerateIdentifier]);

    final csvString = const ListToCsvConverter().convert(rows);
    
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/folium_identifiers_$timestamp.csv');
    
    await file.writeAsString(csvString);
    return file;
  }

  /// Export identifiers to Excel (XLSX) format
  Future<File> exportToExcel() async {
    final settings = await _getSettings();
    final plants = await _plantRepo.getPaginated(limit: 100000);
    
    // Filter only plants with identifiers
    final plantsWithIdentifiers = plants
        .where((p) => p.registryIdentifier != null)
        .toList();

    final excel = Excel.createExcel();
    
    // Create main data sheet
    final dataSheet = excel['Identifiers'];
    
    // Headers
    dataSheet.appendRow([
      TextCellValue('Plant UUID'),
      TextCellValue('Identifier'),
      TextCellValue('Scientific Name'),
      TextCellValue('Common Name'),
      TextCellValue('Date Collected'),
    ]);

    // Data rows
    for (final plant in plantsWithIdentifiers) {
      dataSheet.appendRow([
        TextCellValue(plant.uuid),
        TextCellValue(plant.registryIdentifier ?? ''),
        TextCellValue(plant.scientificName),
        TextCellValue(plant.commonName),
        TextCellValue(plant.dateCollected.toIso8601String()),
      ]);
    }

    // Create configuration sheet
    final configSheet = excel['Configuration'];
    configSheet.appendRow([
      TextCellValue('Setting'),
      TextCellValue('Value'),
    ]);
    configSheet.appendRow([
      TextCellValue('User Initials'),
      TextCellValue(settings.userInitials),
    ]);
    configSheet.appendRow([
      TextCellValue('Last Registry Number'),
      IntCellValue(settings.lastRegistryNumber),
    ]);
    configSheet.appendRow([
      TextCellValue('Auto Generate'),
      TextCellValue(settings.autoGenerateIdentifier.toString()),
    ]);
    configSheet.appendRow([
      TextCellValue('Export Date'),
      TextCellValue(DateTime.now().toIso8601String()),
    ]);

    // Remove default sheet if it exists
    excel.delete('Sheet1');

    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/folium_identifiers_$timestamp.xlsx');
    
    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    
    return file;
  }

  /// Share exported file
  Future<void> shareExport(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Folium - Exportação de Identificadores',
    );
  }

  /// Import identifiers from JSON
  Future<ImportResult> importFromJson(String filePath) async {
    try {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final data = json.decode(jsonString) as Map<String, dynamic>;

      // Validate version
      if (data['version'] != '1.0') {
        return ImportResult(
          success: false,
          message: 'Versão do arquivo incompatível',
        );
      }

      // Extract data
      final config = data['identifierConfig'] as Map<String, dynamic>;
      final identifiers = data['assignedIdentifiers'] as List<dynamic>;

      int importedCount = 0;
      int skippedCount = 0;
      int conflictCount = 0;

      // Import identifiers
      for (final item in identifiers) {
        final plantUuid = _sanitizeCell(item['plantUuid'] as String?);
        final identifier = _sanitizeCell(item['identifier'] as String?);

        if (plantUuid == null || identifier == null) {
          skippedCount++;
          continue;
        }
        if (!_isValidUuid(plantUuid) || !_isValidIdentifier(identifier)) {
          skippedCount++;
          continue;
        }

        final plant = await _plantRepo.getByUuid(plantUuid);
        
        if (plant == null) {
          skippedCount++;
          continue;
        }

        // Check for conflicts
        if (plant.registryIdentifier != null && 
            plant.registryIdentifier != identifier) {
          conflictCount++;
          continue;
        }

        // Assign identifier
        plant.registryIdentifier = identifier;
        await _plantRepo.save(plant);
        importedCount++;
      }

      // Optionally update settings
      final settings = await _getSettings();
      if (config['lastRegistryNumber'] is int &&
          config['lastRegistryNumber'] > settings.lastRegistryNumber) {
        settings.lastRegistryNumber = config['lastRegistryNumber'];
        settings.userInitials = config['userInitials'] ?? settings.userInitials;
        await _saveSettings(settings);
      }

      return ImportResult(
        success: true,
        message: 'Importação concluída',
        importedCount: importedCount,
        skippedCount: skippedCount,
        conflictCount: conflictCount,
      );
    } catch (e) {
      return ImportResult(
        success: false,
        message: 'Erro ao importar: $e',
      );
    }
  }

  /// Import identifiers from CSV
  Future<ImportResult> importFromCsv(String filePath) async {
    try {
      final file = File(filePath);
      final csvString = await file.readAsString();
      final rows = const CsvToListConverter().convert(csvString);

      if (rows.isEmpty || rows.length < 2) {
        return ImportResult(
          success: false,
          message: 'Arquivo CSV vazio ou inválido',
        );
      }

      int importedCount = 0;
      int skippedCount = 0;
      int conflictCount = 0;

      // Skip header row
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        
        // Skip empty or config rows
        if (row.isEmpty || row[0].toString().startsWith('#')) {
          break;
        }

        if (row.length < 2) continue;

        final plantUuid = _sanitizeCell(row[0].toString());
        final identifier = _sanitizeCell(row[1].toString());

        if (plantUuid == null || identifier == null) continue;
        if (!_isValidUuid(plantUuid) || !_isValidIdentifier(identifier)) {
          skippedCount++;
          continue;
        }

        final plant = await _plantRepo.getByUuid(plantUuid);
        
        if (plant == null) {
          skippedCount++;
          continue;
        }

        // Check for conflicts
        if (plant.registryIdentifier != null && 
            plant.registryIdentifier != identifier) {
          conflictCount++;
          continue;
        }

        // Assign identifier
        plant.registryIdentifier = identifier;
        await _plantRepo.save(plant);
        importedCount++;
      }

      return ImportResult(
        success: true,
        message: 'Importação concluída',
        importedCount: importedCount,
        skippedCount: skippedCount,
        conflictCount: conflictCount,
      );
    } catch (e) {
      return ImportResult(
        success: false,
        message: 'Erro ao importar: $e',
      );
    }
  }

  /// Import identifiers from Excel
  Future<ImportResult> importFromExcel(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      final sheet = excel.tables['Identifiers'];
      if (sheet == null) {
        return ImportResult(
          success: false,
          message: 'Planilha "Identifiers" não encontrada',
        );
      }

      int importedCount = 0;
      int skippedCount = 0;
      int conflictCount = 0;

      // Skip header row
      for (int i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];
        
        if (row.length < 2) continue;

        final uuidCell = row[0];
        final identifierCell = row[1];

        if (uuidCell == null || identifierCell == null) continue;

        final plantUuid = _sanitizeCell(uuidCell.value.toString());
        final identifier = _sanitizeCell(identifierCell.value.toString());

        if (plantUuid == null || identifier == null) continue;
        if (!_isValidUuid(plantUuid) || !_isValidIdentifier(identifier)) {
          skippedCount++;
          continue;
        }

        final plant = await _plantRepo.getByUuid(plantUuid);
        
        if (plant == null) {
          skippedCount++;
          continue;
        }

        // Check for conflicts
        if (plant.registryIdentifier != null && 
            plant.registryIdentifier != identifier) {
          conflictCount++;
          continue;
        }

        // Assign identifier
        plant.registryIdentifier = identifier;
        await _plantRepo.save(plant);
        importedCount++;
      }

      // Try to import configuration
      final configSheet = excel.tables['Configuration'];
      if (configSheet != null && configSheet.rows.length > 1) {
        try {
          final settings = await _getSettings();
          bool settingsChanged = false;

          for (int i = 1; i < configSheet.rows.length; i++) {
            final row = configSheet.rows[i];
            if (row.length < 2) continue;

            final key = row[0]?.value.toString();
            final value = row[1]?.value;

            if (key == 'User Initials' && value != null) {
              settings.userInitials = value.toString();
              settingsChanged = true;
            } else if (key == 'Last Registry Number' && value != null) {
              final number = int.tryParse(value.toString());
              if (number != null && number > settings.lastRegistryNumber) {
                settings.lastRegistryNumber = number;
                settingsChanged = true;
              }
            }
          }

          if (settingsChanged) {
            await _saveSettings(settings);
          }
        } catch (e) {
          // Configuration import is optional, don't fail the whole import
          _log.w('Could not import configuration', error: e);
        }
      }

      return ImportResult(
        success: true,
        message: 'Importação concluída',
        importedCount: importedCount,
        skippedCount: skippedCount,
        conflictCount: conflictCount,
      );
    } catch (e) {
      return ImportResult(
        success: false,
        message: 'Erro ao importar: $e',
      );
    }
  }

  /// Pick a file and import based on extension
  Future<ImportResult> pickAndImport() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'csv', 'xlsx', 'xls'],
      );

      if (result == null || result.files.isEmpty) {
        return ImportResult(
          success: false,
          message: 'Nenhum arquivo selecionado',
        );
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        return ImportResult(
          success: false,
          message: 'Caminho do arquivo inválido',
        );
      }

      final extension = filePath.split('.').last.toLowerCase();

      switch (extension) {
        case 'json':
          return await importFromJson(filePath);
        case 'csv':
          return await importFromCsv(filePath);
        case 'xlsx':
        case 'xls':
          return await importFromExcel(filePath);
        default:
          return ImportResult(
            success: false,
            message: 'Formato de arquivo não suportado: $extension',
          );
      }
    } catch (e) {
      return ImportResult(
        success: false,
        message: 'Erro ao selecionar arquivo: $e',
      );
    }
  }

  Future<Settings> _getSettings() async {
    final isar = await IsarService.instance.isar;
    var settings = await isar.settings.get(1);
    
    if (settings == null) {
      throw StateError('Settings not initialized');
    }
    
    return settings;
  }

  Future<void> _saveSettings(Settings settings) async {
    final isar = await IsarService.instance.isar;
    await isar.writeTxn(() async {
      await isar.settings.put(settings);
    });
  }
}

/// Result of an import operation
class ImportResult {
  final bool success;
  final String message;
  final int importedCount;
  final int skippedCount;
  final int conflictCount;

  ImportResult({
    required this.success,
    required this.message,
    this.importedCount = 0,
    this.skippedCount = 0,
    this.conflictCount = 0,
  });

  String get detailedMessage {
    if (!success) return message;
    
    final parts = <String>[];
    if (importedCount > 0) {
      parts.add('$importedCount importado(s)');
    }
    if (skippedCount > 0) {
      parts.add('$skippedCount ignorado(s)');
    }
    if (conflictCount > 0) {
      parts.add('$conflictCount conflito(s)');
    }
    
    return parts.isEmpty ? message : parts.join(', ');
  }
}
