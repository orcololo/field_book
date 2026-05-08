import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'package:field_book/core/repositories/plant_repository.dart';
import 'package:field_book/models/determination.dart';
import 'package:field_book/models/plant_category.dart';
import 'package:field_book/models/plant_record.dart';

import '../../test_helpers/isar_test_helper.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

int _seq = 0;
String _uid([String prefix = 'p']) => '$prefix-${++_seq}';

/// Sentinel meaning "auto-generate a unique registryIdentifier".
const Object _kAutoId = Object();

/// Builds a minimal valid [PlantRecord].
///
/// NOTE: Isar 3 treats null as a unique value for [@Index(unique: true)]
/// fields. To avoid constraint violations, each record receives a unique
/// auto-generated registryIdentifier unless [registryIdentifier] is
/// explicitly overridden. Pass `registryIdentifier: null` only when you need
/// a nullable record — and only ONE such record per test.
PlantRecord _makeRecord({
  String? uuid,
  String scientificName = 'Mimosa pudica',
  PlantCategory category = PlantCategory.herbs,
  DateTime? dateCollected,
  Object? registryIdentifier = _kAutoId,
  String? sessionId,
  double? latitude,
  double? longitude,
  String? collectorNumber,
  String? family,
  String? genus,
  bool isDraft = false,
}) {
  final now = DateTime.now();
  final record = PlantRecord()
    ..uuid = uuid ?? _uid('auto')
    ..scientificName = scientificName
    ..category = category
    ..dateCollected = dateCollected ?? now
    ..deviceId = 'test-device'
    ..createdAt = now
    ..updatedAt = now
    ..isDraft = isDraft;

  record.registryIdentifier = identical(registryIdentifier, _kAutoId)
      ? 'REC-${_uid('id')}'
      : registryIdentifier as String?;

  if (sessionId != null) record.sessionId = sessionId;
  if (latitude != null) record.latitude = latitude;
  if (longitude != null) record.longitude = longitude;
  if (collectorNumber != null) record.collectorNumber = collectorNumber;
  if (family != null) record.family = family;
  if (genus != null) record.genus = genus;

  return record;
}

void main() {
  late Isar isar;
  late Directory dir;
  late PlantRepository repo;

  setUp(() async {
    (isar, dir) = await openTestIsar();
    repo = PlantRepository();
  });

  tearDown(() async => closeTestIsar(isar, dir));

  // ---------------------------------------------------------------------------
  group('save + getById', () {
    test('persists a new record and getById retrieves it', () async {
      final rec = _makeRecord(uuid: _uid());
      await repo.save(rec);

      final found = await repo.getById(rec.id);
      expect(found, isNotNull);
      expect(found!.uuid, rec.uuid);
      expect(found.scientificName, 'Mimosa pudica');
    });

    test('updates an existing record in place', () async {
      final rec = _makeRecord(uuid: _uid());
      await repo.save(rec);
      rec.scientificName = 'Mimosa sensitiva';
      await repo.save(rec);

      expect((await repo.getById(rec.id))!.scientificName, 'Mimosa sensitiva');
    });

    test('sets updatedAt automatically', () async {
      final before = DateTime.now().subtract(const Duration(seconds: 1));
      final rec = _makeRecord(uuid: _uid());
      await repo.save(rec);
      expect((await repo.getById(rec.id))!.updatedAt.isAfter(before), isTrue);
    });

    test('populates FTS fields', () async {
      final rec = _makeRecord(uuid: _uid(), scientificName: 'Byrsonima crassifolia');
      rec.commonName = 'Murici';
      await repo.save(rec);
      final found = await repo.getById(rec.id);
      expect(found!.scientificNameFts, 'byrsonima crassifolia');
      expect(found.commonNameFts, 'murici');
    });
  });

  // ---------------------------------------------------------------------------
  group('getByUuid', () {
    test('returns record matching uuid', () async {
      final uuid = _uid();
      await repo.save(_makeRecord(uuid: uuid));
      expect((await repo.getByUuid(uuid))!.uuid, uuid);
    });

    test('returns null for unknown uuid', () async {
      expect(await repo.getByUuid('nonexistent-uuid'), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  group('delete', () {
    test('removes the record by id', () async {
      final rec = _makeRecord(uuid: _uid());
      await repo.save(rec);
      await repo.delete(rec.id);
      expect(await repo.getById(rec.id), isNull);
    });

    test('does not throw for non-existent id', () async {
      await expectLater(repo.delete(99999), completes);
    });
  });

  // ---------------------------------------------------------------------------
  group('getPaginated', () {
    setUp(() async {
      for (var i = 0; i < 4; i++) {
        await repo.save(_makeRecord(
          uuid: _uid(), category: PlantCategory.herbs,
          dateCollected: DateTime(2024, 1, i + 1),
        ));
      }
      for (var i = 0; i < 2; i++) {
        await repo.save(_makeRecord(
          uuid: _uid(), category: PlantCategory.trees,
          dateCollected: DateTime(2024, 2, i + 1),
        ));
      }
      await repo.save(_makeRecord(
        uuid: _uid(), category: PlantCategory.herbs, isDraft: true,
        dateCollected: DateTime(2024, 3, 1),
      ));
    });

    test('returns all 7 when no filters', () async {
      expect((await repo.getPaginated(limit: 100)).length, 7);
    });

    test('filters by category', () async {
      final herbs = await repo.getPaginated(category: PlantCategory.herbs, limit: 100);
      expect(herbs.length, 5);
    });

    test('filters by isDraft', () async {
      expect((await repo.getPaginated(isDraft: true, limit: 100)).length, 1);
    });

    test('filters by category AND isDraft', () async {
      final draftHerbs = await repo.getPaginated(
          category: PlantCategory.herbs, isDraft: true, limit: 100);
      expect(draftHerbs.length, 1);
    });

    test('respects limit', () async {
      expect((await repo.getPaginated(limit: 3)).length, 3);
    });

    test('respects offset', () async {
      final first = await repo.getPaginated(offset: 0, limit: 4);
      final second = await repo.getPaginated(offset: 4, limit: 4);
      expect({...first.map((p) => p.id), ...second.map((p) => p.id)}.length, 7);
    });
  });

  // ---------------------------------------------------------------------------
  group('fullTextSearch', () {
    setUp(() async {
      await repo.save(_makeRecord(uuid: _uid(), scientificName: 'Mimosa pudica'));
      final rec = _makeRecord(uuid: _uid(), scientificName: 'Byrsonima crassifolia');
      rec.commonName = 'Murici';
      await repo.save(rec);
    });

    test('finds by partial scientific name', () async {
      final r = await repo.fullTextSearch('mimosa', limit: 10);
      expect(r.length, 1);
      expect(r.first.scientificName, 'Mimosa pudica');
    });

    test('finds by common name', () async {
      expect((await repo.fullTextSearch('murici', limit: 10)).length, 1);
    });

    test('returns empty for no match', () async {
      expect(await repo.fullTextSearch('zzznomatch', limit: 10), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('searchByIdentifier', () {
    setUp(() async {
      await repo.save(_makeRecord(uuid: _uid(), registryIdentifier: 'RC000001'));
      await repo.save(_makeRecord(uuid: _uid(), registryIdentifier: 'RC000002'));
    });

    test('exact match returns one result', () async {
      final r = await repo.searchByIdentifier('RC000001');
      expect(r.length, 1);
      expect(r.first.registryIdentifier, 'RC000001');
    });

    test('prefix match returns 2 results', () async {
      expect((await repo.searchByIdentifier('RC0000', limit: 10)).length, 2);
    });

    test('empty string returns empty list', () async {
      expect(await repo.searchByIdentifier(''), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('searchByDateRange', () {
    setUp(() async {
      await repo.save(_makeRecord(uuid: _uid(), dateCollected: DateTime(2024, 1, 10)));
      await repo.save(_makeRecord(uuid: _uid(), dateCollected: DateTime(2024, 6, 15)));
      await repo.save(_makeRecord(uuid: _uid(), dateCollected: DateTime(2025, 3, 5)));
    });

    test('returns records within range', () async {
      final r = await repo.searchByDateRange(
          start: DateTime(2024, 1, 1), end: DateTime(2024, 12, 31), limit: 10);
      expect(r.length, 2);
    });

    test('returns empty when nothing in range', () async {
      final r = await repo.searchByDateRange(
          start: DateTime(2030, 1, 1), end: DateTime(2030, 12, 31), limit: 10);
      expect(r, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('getBySession', () {
    test('returns plants for session, excludes others', () async {
      const sid = 'session-abc';
      await repo.save(_makeRecord(uuid: _uid(), sessionId: sid, dateCollected: DateTime(2024, 1, 1)));
      await repo.save(_makeRecord(uuid: _uid(), sessionId: sid, dateCollected: DateTime(2024, 6, 1)));
      await repo.save(_makeRecord(uuid: _uid(), sessionId: 'other'));

      final r = await repo.getBySession(sid);
      expect(r.length, 2);
      expect(r.every((p) => p.sessionId == sid), isTrue);
    });

    test('returns empty for unknown session', () async {
      expect(await repo.getBySession('ghost'), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('count', () {
    setUp(() async {
      await repo.save(_makeRecord(uuid: _uid(), category: PlantCategory.trees));
      await repo.save(_makeRecord(uuid: _uid(), category: PlantCategory.herbs));
      await repo.save(_makeRecord(uuid: _uid(), category: PlantCategory.herbs, isDraft: true));
    });

    test('counts all', () async { expect(await repo.count(), 3); });
    test('counts by category', () async { expect(await repo.count(category: PlantCategory.herbs), 2); });
    test('counts by isDraft', () async { expect(await repo.count(isDraft: true), 1); });
    test('counts by category AND isDraft', () async {
      expect(await repo.count(category: PlantCategory.herbs, isDraft: true), 1);
    });
  });

  // ---------------------------------------------------------------------------
  group('bulkDelete + getByIds', () {
    test('bulkDelete removes specified records', () async {
      final a = _makeRecord(uuid: _uid());
      final b = _makeRecord(uuid: _uid());
      final c = _makeRecord(uuid: _uid());
      await repo.save(a); await repo.save(b); await repo.save(c);

      await repo.bulkDelete([a.id, b.id]);
      expect(await repo.count(), 1);
    });

    test('getByIds returns only matching records', () async {
      final a = _makeRecord(uuid: _uid());
      final b = _makeRecord(uuid: _uid());
      await repo.save(a); await repo.save(b);

      expect((await repo.getByIds([a.id, b.id, 99999])).length, 2);
    });
  });

  // ---------------------------------------------------------------------------
  group('identifierExists + findByIdentifier', () {
    test('returns true when identifier exists', () async {
      await repo.save(_makeRecord(uuid: _uid(), registryIdentifier: 'RC-EXIST'));
      expect(await repo.identifierExists('RC-EXIST'), isTrue);
    });

    test('returns false for unknown identifier', () async {
      expect(await repo.identifierExists('RC-GHOST'), isFalse);
    });

    test('excludes owner uuid → returns false', () async {
      final uid = _uid('ex');
      await repo.save(_makeRecord(uuid: uid, registryIdentifier: 'RC-OWN'));
      expect(await repo.identifierExists('RC-OWN', excludeUuid: uid), isFalse);
    });

    test('excludes non-owner uuid → still returns true', () async {
      final uid = _uid('ex2');
      final uid2 = _uid('ex3');
      await repo.save(_makeRecord(uuid: uid, registryIdentifier: 'RC-A'));
      await repo.save(_makeRecord(uuid: uid2, registryIdentifier: 'RC-B'));
      // RC-A exists and uid2 doesn't own it
      expect(await repo.identifierExists('RC-A', excludeUuid: uid2), isTrue);
    });

    test('findByIdentifier returns correct record', () async {
      await repo.save(_makeRecord(uuid: _uid(), registryIdentifier: 'RC-FIND'));
      expect((await repo.findByIdentifier('RC-FIND'))!.registryIdentifier, 'RC-FIND');
    });

    test('findByIdentifier returns null when missing', () async {
      expect(await repo.findByIdentifier('RC-NOPE'), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  group('addDetermination', () {
    test('appends determination and updates scientificName', () async {
      final uid = _uid('det');
      await repo.save(_makeRecord(uuid: uid, scientificName: 'Mimosa sp.'));

      await repo.addDetermination(uid, Determination()
        ..determinedBy = 'Dr. Smith'
        ..determinedAt = DateTime(2024, 6, 1)
        ..scientificName = 'Mimosa pudica'
        ..family = 'Fabaceae');

      final found = await repo.getByUuid(uid);
      expect(found!.scientificName, 'Mimosa pudica');
      expect(found.determinations.length, 1);
    });

    test('throws StateError for unknown uuid', () async {
      await expectLater(
        repo.addDetermination('uuid-ghost', Determination()
          ..scientificName = 'X'
          ..determinedAt = DateTime.now()),
        throwsStateError,
      );
    });
  });

  // ---------------------------------------------------------------------------
  group('markAsDuplicate + getDuplicateSeries', () {
    test('links duplicate to original', () async {
      final uidA = _uid('orig'); final uidB = _uid('dup');
      await repo.save(_makeRecord(uuid: uidA));
      await repo.save(_makeRecord(uuid: uidB));

      await repo.markAsDuplicate(duplicateUuid: uidB, originalUuid: uidA);

      expect((await repo.getByUuid(uidB))!.duplicateOf, uidA);
      expect((await repo.getByUuid(uidA))!.duplicateUuids, contains(uidB));
    });

    test('throws ArgumentError when duplicating to self', () async {
      final uid = _uid('self');
      await repo.save(_makeRecord(uuid: uid));
      await expectLater(
        repo.markAsDuplicate(duplicateUuid: uid, originalUuid: uid),
        throwsArgumentError,
      );
    });

    test('getDuplicateSeries returns root + all duplicates', () async {
      final uidRoot = _uid('root');
      final uidD1 = _uid('d1');
      final uidD2 = _uid('d2');
      await repo.save(_makeRecord(uuid: uidRoot));
      await repo.save(_makeRecord(uuid: uidD1));
      await repo.save(_makeRecord(uuid: uidD2));

      await repo.markAsDuplicate(duplicateUuid: uidD1, originalUuid: uidRoot);
      await repo.markAsDuplicate(duplicateUuid: uidD2, originalUuid: uidRoot);

      final series = await repo.getDuplicateSeries(uidD1);
      expect(series.map((p) => p.uuid).toSet(), containsAll([uidRoot, uidD1, uidD2]));
    });
  });

  // ---------------------------------------------------------------------------
  group('getAllIdentifiers', () {
    test('returns sorted non-null identifiers', () async {
      await repo.save(_makeRecord(uuid: _uid(), registryIdentifier: 'RC-003'));
      await repo.save(_makeRecord(uuid: _uid(), registryIdentifier: 'RC-001'));
      // One null-identifier record (only one allowed due to unique constraint).
      await repo.save(_makeRecord(uuid: _uid(), registryIdentifier: null));

      final ids = await repo.getAllIdentifiers();
      expect(ids, containsAll(['RC-001', 'RC-003']));
      expect(ids.any((s) => s.contains('REC-')), isFalse,
          reason: 'auto-generated IDs should not appear — null record has no identifier');
    });
  });

  // ---------------------------------------------------------------------------
  group('getDistinctFamilies + getDistinctGenera', () {
    setUp(() async {
      await repo.save(_makeRecord(uuid: _uid(), family: 'Fabaceae', genus: 'Mimosa'));
      await repo.save(_makeRecord(uuid: _uid(), family: 'Fabaceae', genus: 'Acacia'));
      await repo.save(_makeRecord(uuid: _uid(), family: 'Myrtaceae', genus: 'Eucalyptus'));
      await repo.save(_makeRecord(uuid: _uid())); // no family/genus
    });

    test('getDistinctFamilies returns unique sorted families', () async {
      final f = await repo.getDistinctFamilies();
      expect(f, containsAll(['Fabaceae', 'Myrtaceae']));
      expect(f.length, 2);
    });

    test('getDistinctGenera returns unique sorted genera', () async {
      final g = await repo.getDistinctGenera();
      expect(g, containsAll(['Acacia', 'Eucalyptus', 'Mimosa']));
      expect(g.length, 3);
    });
  });

  // ---------------------------------------------------------------------------
  group('searchByCollectorNumber', () {
    setUp(() async {
      await repo.save(_makeRecord(uuid: _uid(), collectorNumber: 'AB-001'));
      await repo.save(_makeRecord(uuid: _uid(), collectorNumber: 'AB-002'));
      await repo.save(_makeRecord(uuid: _uid(), collectorNumber: 'CD-003'));
    });

    test('returns prefix-matching records', () async {
      expect((await repo.searchByCollectorNumber('AB', limit: 10)).length, 2);
    });

    test('empty query returns empty list', () async {
      expect(await repo.searchByCollectorNumber(''), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('getPlantsWithoutIdentifier', () {
    test('returns only records with null registryIdentifier', () async {
      await repo.save(_makeRecord(uuid: _uid(), registryIdentifier: 'RC-HAS'));
      await repo.save(_makeRecord(uuid: _uid(), registryIdentifier: null)); // 1 null
      await repo.save(_makeRecord(uuid: _uid(), registryIdentifier: 'RC-HAS2'));

      final r = await repo.getPlantsWithoutIdentifier();
      expect(r.length, 1);
      expect(r.first.registryIdentifier, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  group('searchByGpsRadius', () {
    setUp(() async {
      // São Paulo ~(-23.55, -46.63)
      await repo.save(_makeRecord(uuid: _uid(), latitude: -23.55, longitude: -46.63));
      // Campinas ~(-22.90, -47.06) — ~75 km away
      await repo.save(_makeRecord(uuid: _uid(), latitude: -22.90, longitude: -47.06));
    });

    test('finds only nearby record within 5 km', () async {
      final r = await repo.searchByGpsRadius(
          latitude: -23.55, longitude: -46.63, radiusKm: 5);
      expect(r.length, 1);
    });

    test('finds both when radius is large', () async {
      final r = await repo.searchByGpsRadius(
          latitude: -23.55, longitude: -46.63, radiusKm: 200);
      expect(r.length, 2);
    });
  });

  // ---------------------------------------------------------------------------
  group('getByUuids', () {
    test('returns records matching any uuid in list', () async {
      final uidA = _uid('ua'); final uidB = _uid('ub');
      await repo.save(_makeRecord(uuid: uidA));
      await repo.save(_makeRecord(uuid: uidB));
      expect((await repo.getByUuids([uidA, uidB])).length, 2);
    });

    test('empty list returns empty list', () async {
      expect(await repo.getByUuids([]), isEmpty);
    });
  });
}
