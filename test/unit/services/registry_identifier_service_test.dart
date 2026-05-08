import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'package:field_book/core/repositories/plant_repository.dart';
import 'package:field_book/core/services/registry_identifier_service.dart';
import 'package:field_book/models/plant_category.dart';
import 'package:field_book/models/plant_record.dart';
import 'package:field_book/models/settings.dart';

import '../../test_helpers/isar_test_helper.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

int _seq = 0;
String _uid([String prefix = 'r']) => '$prefix-${++_seq}';

/// Seed the singleton Settings record (id=1) required by the service.
Future<void> _seedSettings(
  Isar isar, {
  String userInitials = 'RC',
  int lastRegistryNumber = 0,
}) async {
  final settings = Settings()
    ..id = 1
    ..userInitials = userInitials
    ..lastRegistryNumber = lastRegistryNumber
    ..deviceId = 'test-device'
    ..deviceName = 'Test Device'
    ..createdAt = DateTime.now();

  await isar.writeTxn(() async {
    await isar.settings.put(settings);
  });
}

/// Build a minimal [PlantRecord] with a unique registryIdentifier.
const Object _kAutoId = Object();

PlantRecord _makePlant({
  String? uuid,
  String? sessionId,
  Object? registryIdentifier = _kAutoId,
}) {
  final now = DateTime.now();
  final p = PlantRecord()
    ..uuid = uuid ?? _uid('puuid')
    ..scientificName = 'Mimosa pudica'
    ..category = PlantCategory.herbs
    ..dateCollected = now
    ..deviceId = 'test-device'
    ..createdAt = now
    ..updatedAt = now
    ..isDraft = false;

  p.registryIdentifier = identical(registryIdentifier, _kAutoId)
      ? 'PLT-${_uid('pid')}'
      : registryIdentifier as String?;

  if (sessionId != null) p.sessionId = sessionId;
  return p;
}

// ---------------------------------------------------------------------------
void main() {
  late Isar isar;
  late Directory dir;
  late PlantRepository plantRepo;
  late RegistryIdentifierService svc;

  setUp(() async {
    (isar, dir) = await openTestIsar();
    plantRepo = PlantRepository();
    svc = RegistryIdentifierService(plantRepository: plantRepo);
    await _seedSettings(isar);
  });

  tearDown(() async => closeTestIsar(isar, dir));

  // ---------------------------------------------------------------------------
  // Pure / synchronous methods (no Isar required)
  // ---------------------------------------------------------------------------

  group('formatIdentifier', () {
    test('formats with zero-padded 6-digit number', () {
      expect(svc.formatIdentifier('RC', 1), 'RC000001');
      expect(svc.formatIdentifier('RC', 42), 'RC000042');
      expect(svc.formatIdentifier('RC', 999999), 'RC999999');
    });

    test('accepts 1–4 letter prefixes', () {
      expect(svc.formatIdentifier('A', 1), 'A000001');
      expect(svc.formatIdentifier('ABCD', 1), 'ABCD000001');
    });

    test('throws ArgumentError for negative numbers', () {
      expect(() => svc.formatIdentifier('RC', -1), throwsArgumentError);
    });

    test('throws ArgumentError for number > 999999', () {
      expect(() => svc.formatIdentifier('RC', 1000000), throwsArgumentError);
    });
  });

  // ---------------------------------------------------------------------------
  group('isValidIdentifier', () {
    test('accepts valid identifiers', () {
      expect(svc.isValidIdentifier('RC000001'), isTrue);
      expect(svc.isValidIdentifier('A1'), isTrue);
      expect(svc.isValidIdentifier('ABCD999999'), isTrue);
    });

    test('rejects empty string', () {
      expect(svc.isValidIdentifier(''), isFalse);
    });

    test('rejects lowercase letters', () {
      expect(svc.isValidIdentifier('rc000001'), isFalse);
    });

    test('rejects digits-only', () {
      expect(svc.isValidIdentifier('000001'), isFalse);
    });

    test('rejects letters-only', () {
      expect(svc.isValidIdentifier('RCABC'), isFalse);
    });

    test('rejects 5 leading letters (max 4)', () {
      expect(svc.isValidIdentifier('ABCDE1'), isFalse);
    });

    test('rejects 7+ digits (max 6)', () {
      expect(svc.isValidIdentifier('RC0000001'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  group('parseIdentifier', () {
    test('parses valid identifier correctly', () {
      final result = svc.parseIdentifier('RC000042');
      expect(result, isNotNull);
      expect(result!.initials, 'RC');
      expect(result.number, 42);
    });

    test('parses single-letter prefix', () {
      final result = svc.parseIdentifier('A1');
      expect(result!.initials, 'A');
      expect(result.number, 1);
    });

    test('returns null for invalid identifier', () {
      expect(svc.parseIdentifier('invalid'), isNull);
      expect(svc.parseIdentifier(''), isNull);
      expect(svc.parseIdentifier('ABCDE1'), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  group('sanitizeInitials', () {
    test('uppercases valid lowercase input', () {
      expect(svc.sanitizeInitials('rc'), 'RC');
    });

    test('trims surrounding whitespace', () {
      expect(svc.sanitizeInitials(' RC '), 'RC');
    });

    test('returns null for null input', () {
      expect(svc.sanitizeInitials(null), isNull);
    });

    test('returns null for empty string', () {
      expect(svc.sanitizeInitials(''), isNull);
    });

    test('returns null for more than 4 letters', () {
      expect(svc.sanitizeInitials('ABCDE'), isNull);
    });

    test('returns null for digits or special chars', () {
      expect(svc.sanitizeInitials('R2'), isNull);
      expect(svc.sanitizeInitials('R-C'), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Async / database-backed methods
  // ---------------------------------------------------------------------------

  group('generateNextIdentifier', () {
    test('returns RC000001 when lastRegistryNumber is 0', () async {
      final id = await svc.generateNextIdentifier();
      expect(id, 'RC000001');
    });

    test('increments on successive calls', () async {
      final id1 = await svc.generateNextIdentifier();
      final id2 = await svc.generateNextIdentifier();
      expect(id1, 'RC000001');
      expect(id2, 'RC000002');
    });

    test('uses current userInitials from settings', () async {
      await svc.setUserInitials('AB');
      final id = await svc.generateNextIdentifier();
      expect(id.startsWith('AB'), isTrue);
    });

    test('skips an already-used identifier', () async {
      // Pre-occupy RC000001.
      final plant = _makePlant(registryIdentifier: 'RC000001');
      await plantRepo.save(plant);

      // generateNextIdentifier should skip RC000001 and return RC000002.
      final id = await svc.generateNextIdentifier();
      expect(id, 'RC000002');
    });

    test('throws Exception when Settings not found', () async {
      // Delete the settings record.
      await isar.writeTxn(() async => isar.settings.delete(1));

      await expectLater(
        svc.generateNextIdentifier(),
        throwsA(isA<Exception>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  group('previewNextIdentifier', () {
    test('returns next identifier without advancing the counter', () async {
      final preview = await svc.previewNextIdentifier();
      expect(preview, 'RC000001');

      // Counter should not have advanced.
      final preview2 = await svc.previewNextIdentifier();
      expect(preview2, 'RC000001');
    });

    test('reflects current lastRegistryNumber', () async {
      await _seedSettings(isar, lastRegistryNumber: 5);
      final preview = await svc.previewNextIdentifier();
      expect(preview, 'RC000006');
    });
  });

  // ---------------------------------------------------------------------------
  group('setLastRegistryNumber', () {
    test('updates the registry number', () async {
      await svc.setLastRegistryNumber(100);
      final preview = await svc.previewNextIdentifier();
      expect(preview, 'RC000101');
    });

    test('throws ArgumentError for negative number', () async {
      await expectLater(
        svc.setLastRegistryNumber(-1),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws ArgumentError for number > 999999', () async {
      await expectLater(
        svc.setLastRegistryNumber(1000000),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('accepts 0 (reset)', () async {
      await svc.setLastRegistryNumber(50);
      await svc.setLastRegistryNumber(0);
      expect(await svc.previewNextIdentifier(), 'RC000001');
    });
  });

  // ---------------------------------------------------------------------------
  group('setUserInitials', () {
    test('updates initials in settings', () async {
      await svc.setUserInitials('AB');
      final preview = await svc.previewNextIdentifier();
      expect(preview.startsWith('AB'), isTrue);
    });

    test('accepts lowercase — sanitizes to uppercase', () async {
      await svc.setUserInitials('ab');
      final preview = await svc.previewNextIdentifier();
      expect(preview.startsWith('AB'), isTrue);
    });

    test('throws ArgumentError for invalid initials', () async {
      await expectLater(
        svc.setUserInitials('ABCDE'),
        throwsA(isA<ArgumentError>()),
      );
      await expectLater(
        svc.setUserInitials(''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  group('identifierExists', () {
    test('returns true when identifier exists', () async {
      final plant = _makePlant(registryIdentifier: 'RC000099');
      await plantRepo.save(plant);
      expect(await svc.identifierExists('RC000099'), isTrue);
    });

    test('returns false when identifier does not exist', () async {
      expect(await svc.identifierExists('RC999999'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  group('getAllIdentifiers', () {
    test('returns list of existing identifiers', () async {
      await plantRepo.save(_makePlant(registryIdentifier: 'RC000010'));
      await plantRepo.save(_makePlant(registryIdentifier: 'RC000020'));

      final ids = await svc.getAllIdentifiers();
      expect(ids, containsAll(['RC000010', 'RC000020']));
    });

    test('returns empty list when no plants exist', () async {
      expect(await svc.getAllIdentifiers(), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('validateCustomIdentifier', () {
    test('returns null for valid unused identifier', () async {
      expect(await svc.validateCustomIdentifier('RC000099'), isNull);
    });

    test('returns error message for invalid format', () async {
      final msg = await svc.validateCustomIdentifier('invalid');
      expect(msg, isNotNull);
      expect(msg, isA<String>());
    });

    test('returns error message when identifier already exists', () async {
      await plantRepo.save(_makePlant(registryIdentifier: 'RC000005'));
      final msg = await svc.validateCustomIdentifier('RC000005');
      expect(msg, isNotNull);
    });

    test('excludeUuid ignores the owning plant', () async {
      final plant = _makePlant(registryIdentifier: 'RC000005');
      await plantRepo.save(plant);

      // Validating the same identifier for its own plant should pass.
      final msg = await svc.validateCustomIdentifier(
        'RC000005',
        excludePlantUuid: plant.uuid,
      );
      expect(msg, isNull);
    });
  });
}
