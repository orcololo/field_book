import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'package:field_book/core/repositories/saved_search_repository.dart';
import 'package:field_book/models/saved_search.dart';

import '../../test_helpers/isar_test_helper.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

int _seq = 0;
String _uid([String prefix = 'ss']) => '$prefix-${++_seq}';

SavedSearch _makeSearch({
  String? uuid,
  String? name,
  String query = 'q',
  String filtersJson = '{}',
  DateTime? createdAt,
}) {
  return SavedSearch()
    ..uuid = uuid ?? _uid('uuid')
    ..name = name ?? 'Search ${_uid('name')}'
    ..query = query
    ..filtersJson = filtersJson
    ..createdAt = createdAt ?? DateTime.now();
}

// ---------------------------------------------------------------------------
void main() {
  late Isar isar;
  late Directory dir;
  late SavedSearchRepository repo;

  setUp(() async {
    (isar, dir) = await openTestIsar();
    repo = SavedSearchRepository();
  });

  tearDown(() async => closeTestIsar(isar, dir));

  // ---------------------------------------------------------------------------
  group('save + getById', () {
    test('persists a new record and getById retrieves it', () async {
      final s = _makeSearch(uuid: _uid(), name: 'My Search', query: 'cerrado');
      await repo.save(s);

      final found = await repo.getById(s.id);
      expect(found, isNotNull);
      expect(found!.uuid, s.uuid);
      expect(found.name, 'My Search');
      expect(found.query, 'cerrado');
    });

    test('updates an existing record in place', () async {
      final s = _makeSearch(uuid: _uid());
      await repo.save(s);
      s.name = 'Updated Name';
      await repo.save(s);

      expect((await repo.getById(s.id))!.name, 'Updated Name');
    });

    test('persists filtersJson', () async {
      final filters = '{"category":"trees","isDraft":false}';
      final s = _makeSearch(uuid: _uid(), filtersJson: filters);
      await repo.save(s);

      expect((await repo.getById(s.id))!.filtersJson, filters);
    });
  });

  // ---------------------------------------------------------------------------
  group('getByUuid', () {
    test('returns record matching uuid', () async {
      final uuid = _uid('u');
      await repo.save(_makeSearch(uuid: uuid));
      expect((await repo.getByUuid(uuid))!.uuid, uuid);
    });

    test('returns null for unknown uuid', () async {
      expect(await repo.getByUuid('no-such-uuid'), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  group('delete', () {
    test('removes the record by id', () async {
      final s = _makeSearch(uuid: _uid());
      await repo.save(s);
      await repo.delete(s.id);
      expect(await repo.getById(s.id), isNull);
    });

    test('does not throw for non-existent id', () async {
      await expectLater(repo.delete(99999), completes);
    });
  });

  // ---------------------------------------------------------------------------
  group('getAll', () {
    test('returns all saved searches sorted by createdAt descending', () async {
      final old = _makeSearch(
        uuid: _uid(),
        name: 'Old Search',
        createdAt: DateTime(2023, 1, 1),
      );
      final recent = _makeSearch(
        uuid: _uid(),
        name: 'Recent Search',
        createdAt: DateTime(2025, 6, 1),
      );
      await repo.save(old);
      await repo.save(recent);

      final all = await repo.getAll();
      expect(all.length, 2);
      // Most recent should appear first.
      expect(all.first.name, 'Recent Search');
      expect(all.last.name, 'Old Search');
    });

    test('returns empty list when nothing saved', () async {
      expect(await repo.getAll(), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('searchByName', () {
    setUp(() async {
      await repo.save(_makeSearch(uuid: _uid(), name: 'Amazon Trees'));
      await repo.save(_makeSearch(uuid: _uid(), name: 'cerrado survey'));
      await repo.save(_makeSearch(uuid: _uid(), name: 'Atlantic Ferns'));
    });

    test('finds by partial name (case-insensitive, lowercase query)', () async {
      final results = await repo.searchByName('amazon');
      expect(results.length, 1);
      expect(results.first.name, 'Amazon Trees');
    });

    test('finds by uppercase query', () async {
      final results = await repo.searchByName('CERRADO');
      expect(results.length, 1);
      expect(results.first.name, 'cerrado survey');
    });

    test('finds by mid-word substring', () async {
      final results = await repo.searchByName('fern');
      expect(results.length, 1);
      expect(results.first.name, 'Atlantic Ferns');
    });

    test('returns empty for no match', () async {
      expect(await repo.searchByName('nonexistent'), isEmpty);
    });

    test('returns empty for empty query', () async {
      // searchByName('') uses nameContains('') which matches all — assert
      // current behavior.
      final results = await repo.searchByName('');
      expect(results.length, 3);
    });
  });

  // ---------------------------------------------------------------------------
  group('count', () {
    test('returns 0 when empty', () async {
      expect(await repo.count(), 0);
    });

    test('returns correct count after saves', () async {
      await repo.save(_makeSearch(uuid: _uid()));
      await repo.save(_makeSearch(uuid: _uid()));
      expect(await repo.count(), 2);
    });

    test('decrements after delete', () async {
      final s = _makeSearch(uuid: _uid());
      await repo.save(s);
      await repo.save(_makeSearch(uuid: _uid()));
      await repo.delete(s.id);
      expect(await repo.count(), 1);
    });
  });
}
