import 'package:isar/isar.dart';
import '../../models/plant_record.dart';
import '../../models/settings.dart';
import '../repositories/plant_repository.dart';
import '../database/isar_service.dart';

/// Service for managing plant registry identifiers
/// Format: {UserInitials}{Number} (e.g., RC000001)
class RegistryIdentifierService {
  final PlantRepository _plantRepository;

  RegistryIdentifierService({required PlantRepository plantRepository})
    : _plantRepository = plantRepository;

  /// Get settings from database
  Future<Settings> _getSettings() async {
    final isar = await IsarService.instance.isar;
    var settings = await isar.settings.get(1);

    if (settings == null) {
      throw StateError('Settings not initialized');
    }

    return settings;
  }

  /// Update settings in database
  Future<void> _updateSettings(Settings settings) async {
    final isar = await IsarService.instance.isar;
    await isar.writeTxn(() async {
      await isar.settings.put(settings);
    });
  }

  /// Generate next registry identifier based on settings
  /// Returns identifier like "RC000001", "RC000002", etc.
  /// Thread-safe: wrapped in atomic transaction to prevent duplicate IDs
  Future<String> generateNextIdentifier() async {
    final isar = await IsarService.instance.isar;

    return await isar.writeTxn(() async {
      final settings = await isar.settings.get(1);
      if (settings == null) {
        throw Exception('Settings not found');
      }

      int number = settings.lastRegistryNumber + 1;

      // Check for number overflow
      if (number > 999999) {
        throw Exception(
          'Registry number limit reached (999999). Please reset in settings.',
        );
      }

      // Try up to 100 numbers to find available identifier
      for (int attempts = 0; attempts < 100; attempts++) {
        final identifier = formatIdentifier(settings.userInitials, number);

        // Check directly within the transaction to avoid deadlocks
        final existingPlant = await isar.plantRecords
            .filter()
            .registryIdentifierEqualTo(identifier)
            .findFirst();

        if (existingPlant == null) {
          // Update settings atomically
          settings.lastRegistryNumber = number;
          await isar.settings.put(settings);
          return identifier;
        }

        number++;

        // Check overflow during collision search
        if (number > 999999) {
          throw Exception(
            'Registry number limit reached during collision resolution',
          );
        }
      }

      throw Exception(
        'Could not generate unique identifier after 100 attempts',
      );
    });
  }

  /// Format identifier with user initials and number
  /// Number is zero-padded to 6 digits
  /// Format identifier with initials and number
  /// Example: formatIdentifier('RC', 42) => 'RC000042'
  String formatIdentifier(String initials, int number) {
    if (number < 0) {
      throw ArgumentError('Registry number cannot be negative');
    }
    if (number > 999999) {
      throw ArgumentError(
        'Registry number cannot exceed 999999 (6-digit limit)',
      );
    }
    return '$initials${number.toString().padLeft(6, '0')}';
  }

  /// Validate identifier format
  /// Valid format: 1-4 uppercase letters + 1-6 digits
  bool isValidIdentifier(String identifier) {
    if (identifier.isEmpty) return false;

    // Pattern: 1-4 uppercase letters followed by digits
    final pattern = RegExp(r'^[A-Z]{1,4}\d{1,6}$');
    return pattern.hasMatch(identifier);
  }

  /// Check if identifier already exists in database
  Future<bool> identifierExists(String identifier) async {
    return await _plantRepository.identifierExists(identifier);
  }

  /// Parse identifier into initials and number
  /// Returns null if invalid format
  ({String initials, int number})? parseIdentifier(String identifier) {
    if (!isValidIdentifier(identifier)) return null;

    // Find where numbers start
    final match = RegExp(r'^([A-Z]+)(\d+)$').firstMatch(identifier);
    if (match == null) return null;

    final initials = match.group(1)!;
    final number = int.parse(match.group(2)!);

    return (initials: initials, number: number);
  }

  /// Validate and sanitize user initials
  /// Converts to uppercase and validates format
  String? sanitizeInitials(String? input) {
    if (input == null || input.isEmpty) return null;

    final sanitized = input.trim().toUpperCase();

    // Check if valid (1-4 letters only)
    if (!RegExp(r'^[A-Z]{1,4}$').hasMatch(sanitized)) {
      return null;
    }

    return sanitized;
  }

  /// Get preview of next identifier without saving
  Future<String> previewNextIdentifier() async {
    final settings = await _getSettings();
    final nextNumber = settings.lastRegistryNumber + 1;
    return formatIdentifier(settings.userInitials, nextNumber);
  }

  /// Update last registry number manually
  /// Useful for resetting or adjusting the sequence
  Future<void> setLastRegistryNumber(int number) async {
    if (number < 0 || number > 999999) {
      throw ArgumentError('Registry number must be between 0 and 999999');
    }

    final settings = await _getSettings();
    settings.lastRegistryNumber = number;
    await _updateSettings(settings);
  }

  /// Update user initials
  Future<void> setUserInitials(String initials) async {
    final sanitized = sanitizeInitials(initials);
    if (sanitized == null) {
      throw ArgumentError(
        'Invalid initials format. Use 1-4 uppercase letters.',
      );
    }

    final settings = await _getSettings();
    settings.userInitials = sanitized;
    await _updateSettings(settings);
  }

  /// Get all existing identifiers (for validation and reports)
  Future<List<String>> getAllIdentifiers() async {
    return await _plantRepository.getAllIdentifiers();
  }

  /// Validate custom identifier and ensure it doesn't exist
  Future<String?> validateCustomIdentifier(
    String identifier, {
    String? excludePlantUuid,
  }) async {
    // Format validation
    if (!isValidIdentifier(identifier)) {
      return 'Formato inválido. Use letras maiúsculas (1-4) + números (até 6 dígitos).';
    }

    // Check if exists (excluding current plant if editing)
    final exists = await _plantRepository.identifierExists(
      identifier,
      excludeUuid: excludePlantUuid,
    );

    if (exists) {
      return 'Este identificador já está em uso.';
    }

    return null; // Valid
  }
}
