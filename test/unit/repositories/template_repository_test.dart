import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'package:field_book/core/repositories/template_repository.dart';
import 'package:field_book/core/utils/biome_detector.dart';
import 'package:field_book/models/collection_template.dart';

import '../../test_helpers/isar_test_helper.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

int _seq = 0;
String _uid([String prefix = 't']) => '$prefix-${++_seq}';

CollectionTemplate _makeTemplate({
  String? uuid,
  String? name,
  String biome = 'test_biome',
  bool isBuiltIn = false,
  String? habitatTemplate,
  String? notesTemplate,
}) {
  return CollectionTemplate()
    ..uuid = uuid ?? _uid('uuid')
    ..name = name ?? 'Template ${_uid('name')}'
    ..biome = biome
    ..isBuiltIn = isBuiltIn
    ..habitatTemplate = habitatTemplate
    ..notesTemplate = notesTemplate;
}

/// Number of built-in biome templates seeded automatically.
const _builtInCount = 6;

// ---------------------------------------------------------------------------
void main() {
  late Isar isar;
  late Directory dir;
  late TemplateRepository repo;

  setUp(() async {
    (isar, dir) = await openTestIsar();
    repo = TemplateRepository();
  });

  tearDown(() async => closeTestIsar(isar, dir));

  // ---------------------------------------------------------------------------
  group('ensureBuiltInTemplates', () {
    test('seeds exactly $_builtInCount built-in templates on first call',
        () async {
      await repo.ensureBuiltInTemplates();
      final all = await isar.collectionTemplates.where().findAll();
      expect(all.length, _builtInCount);
      expect(all.every((t) => t.isBuiltIn), isTrue);
    });

    test('is idempotent — calling twice does not duplicate templates',
        () async {
      await repo.ensureBuiltInTemplates();
      await repo.ensureBuiltInTemplates();
      final all = await isar.collectionTemplates.where().findAll();
      expect(all.length, _builtInCount);
    });
  });

  // ---------------------------------------------------------------------------
  group('save + getById', () {
    test('persists a user template and getById retrieves it', () async {
      final t = _makeTemplate(
        uuid: _uid(),
        name: 'My Template',
        biome: 'restinga',
      );
      await repo.save(t);

      final found = await repo.getById(t.id);
      expect(found, isNotNull);
      expect(found!.uuid, t.uuid);
      expect(found.name, 'My Template');
      expect(found.biome, 'restinga');
    });

    test('updates an existing template in place', () async {
      final t = _makeTemplate(uuid: _uid());
      await repo.save(t);
      t.name = 'Updated Name';
      await repo.save(t);

      expect((await repo.getById(t.id))!.name, 'Updated Name');
    });

    test('persists optional text fields', () async {
      final t = _makeTemplate(
        uuid: _uid(),
        habitatTemplate: 'Open cerrado',
        notesTemplate: 'Record bark',
      );
      await repo.save(t);

      final found = await repo.getById(t.id);
      expect(found!.habitatTemplate, 'Open cerrado');
      expect(found.notesTemplate, 'Record bark');
    });
  });

  // ---------------------------------------------------------------------------
  group('getByUuid', () {
    test('returns template matching uuid', () async {
      final uuid = _uid('u');
      await repo.save(_makeTemplate(uuid: uuid));
      expect((await repo.getByUuid(uuid))!.uuid, uuid);
    });

    test('returns null for unknown uuid', () async {
      expect(await repo.getByUuid('no-such-uuid'), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  group('getAll', () {
    test('includes built-in templates after first call', () async {
      final all = await repo.getAll();
      expect(all.length, greaterThanOrEqualTo(_builtInCount));
      expect(all.any((t) => t.isBuiltIn), isTrue);
    });

    test('built-in templates sorted before user templates', () async {
      await repo.save(_makeTemplate(uuid: _uid(), biome: 'zzz_last'));
      final all = await repo.getAll();
      final builtIns = all.where((t) => t.isBuiltIn).toList();
      final users = all.where((t) => !t.isBuiltIn).toList();
      // All built-ins appear before all user templates.
      if (builtIns.isNotEmpty && users.isNotEmpty) {
        final lastBuiltInIdx = all.indexOf(builtIns.last);
        final firstUserIdx = all.indexOf(users.first);
        expect(lastBuiltInIdx < firstUserIdx, isTrue);
      }
    });

    test('returns user templates in addition to built-ins', () async {
      await repo.save(_makeTemplate(uuid: _uid(), name: 'Extra Template'));
      final all = await repo.getAll();
      expect(all.length, _builtInCount + 1);
      expect(all.any((t) => t.name == 'Extra Template'), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  group('getByBiome', () {
    test('returns built-in cerrado template', () async {
      final results = await repo.getByBiome(BiomeDetector.cerrado);
      expect(results.isNotEmpty, isTrue);
      expect(results.every((t) => t.biome == BiomeDetector.cerrado), isTrue);
    });

    test('returns user template for custom biome', () async {
      await repo.save(_makeTemplate(uuid: _uid(), biome: 'campo_rupestre'));
      final results = await repo.getByBiome('campo_rupestre');
      expect(results.length, 1);
      expect(results.first.biome, 'campo_rupestre');
    });

    test('returns empty for biome with no templates', () async {
      expect(await repo.getByBiome('biome_with_no_data'), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('delete', () {
    test('removes a user template by id', () async {
      final t = _makeTemplate(uuid: _uid());
      await repo.save(t);
      await repo.delete(t.id);
      expect(await repo.getById(t.id), isNull);
    });

    test('throws StateError when deleting a built-in template', () async {
      final all = await repo.getAll();
      final builtIn = all.firstWhere((t) => t.isBuiltIn);

      await expectLater(
        repo.delete(builtIn.id),
        throwsA(isA<StateError>()),
      );
    });

    test('no-op when id does not exist', () async {
      await expectLater(repo.delete(99999), completes);
    });
  });

  // ---------------------------------------------------------------------------
  group('duplicate', () {
    test('returns a new template with same fields but different uuid', () async {
      final original = _makeTemplate(
        uuid: _uid(),
        name: 'Original',
        biome: 'restinga',
        habitatTemplate: 'Sandy coast',
        notesTemplate: 'Check epiphytes',
      );
      await repo.save(original);

      final copy = await repo.duplicate(original);

      expect(copy.uuid, isNot(equals(original.uuid)));
      expect(copy.name, original.name);
      expect(copy.biome, original.biome);
      expect(copy.habitatTemplate, original.habitatTemplate);
      expect(copy.notesTemplate, original.notesTemplate);
      expect(copy.isBuiltIn, isFalse);
    });

    test('duplicate of built-in is not marked as built-in', () async {
      final all = await repo.getAll();
      final builtIn = all.firstWhere((t) => t.isBuiltIn);
      final copy = await repo.duplicate(builtIn);
      expect(copy.isBuiltIn, isFalse);
    });

    test('duplicated template can be saved without error', () async {
      final original = _makeTemplate(uuid: _uid(), biome: 'restinga');
      await repo.save(original);
      final copy = await repo.duplicate(original);
      await expectLater(repo.save(copy), completes);
    });
  });

  // ---------------------------------------------------------------------------
  group('getSuggestedTemplateForCoordinates', () {
    test('returns template for coordinates inside cerrado region', () async {
      // Brasília, DF — firmly in the cerrado biome bounding box.
      final result = await repo.getSuggestedTemplateForCoordinates(
        latitude: -15.8,
        longitude: -47.9,
      );
      expect(result, isNotNull);
      expect(result!.biome, BiomeDetector.cerrado);
    });

    test('returns null for coordinates outside all known biomes', () async {
      // Pacific Ocean — no bounding box should match.
      final result = await repo.getSuggestedTemplateForCoordinates(
        latitude: 0.0,
        longitude: -130.0,
      );
      expect(result, isNull);
    });
  });
}
