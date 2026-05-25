import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'package:field_book/core/repositories/label_template_repository.dart';
import 'package:field_book/models/label_template.dart';

import '../../test_helpers/isar_test_helper.dart';

void main() {
  late Isar isar;
  late Directory dir;
  late LabelTemplateRepository repo;

  setUp(() async {
    (isar, dir) = await openTestIsar();
    repo = LabelTemplateRepository();
  });

  tearDown(() async {
    await closeTestIsar(isar, dir);
  });

  group('LabelTemplateRepository', () {
    test('seedBuiltIns inserts three built-in templates once', () async {
      await repo.seedBuiltIns(
        standardName: 'Standard',
        compactName: 'Compact',
        largeName: 'Large',
      );

      final all = await repo.getAll();
      expect(all, hasLength(3));
      expect(all.every((t) => t.isBuiltIn), isTrue);
      expect(
        all.map((t) => t.uuid).toSet(),
        equals(BuiltInLabelTemplates.allUuids.toSet()),
      );
    });

    test('seedBuiltIns is idempotent across multiple calls', () async {
      await repo.seedBuiltIns(
        standardName: 'Standard',
        compactName: 'Compact',
        largeName: 'Large',
      );
      await repo.seedBuiltIns(
        standardName: 'Renamed',
        compactName: 'Compact',
        largeName: 'Large',
      );

      final all = await repo.getAll();
      expect(all, hasLength(3));
      // Renaming after seeding does not overwrite existing names.
      final standard =
          await repo.getByUuid(BuiltInLabelTemplates.standardUuid);
      expect(standard, isNotNull);
      expect(standard!.name, 'Standard');
    });

    test('delete rejects built-in templates', () async {
      await repo.seedBuiltIns(
        standardName: 'Standard',
        compactName: 'Compact',
        largeName: 'Large',
      );
      final builtIn =
          await repo.getByUuid(BuiltInLabelTemplates.standardUuid);
      expect(builtIn, isNotNull);
      expect(
        () => repo.delete(builtIn!.id),
        throwsA(isA<StateError>()),
      );
    });

    test('save+delete works for custom templates', () async {
      final custom = LabelTemplate.standard(
        uuid: '11111111-1111-4111-8111-111111111111',
        name: 'My Lab',
      )..isBuiltIn = false;
      final id = await repo.save(custom);
      expect(await repo.getById(id), isNotNull);

      await repo.delete(id);
      expect(await repo.getById(id), isNull);
    });

    test('getDefault returns the standard built-in when present', () async {
      await repo.seedBuiltIns(
        standardName: 'Standard',
        compactName: 'Compact',
        largeName: 'Large',
      );
      final def = await repo.getDefault();
      expect(def, isNotNull);
      expect(def!.uuid, BuiltInLabelTemplates.standardUuid);
    });
  });
}
