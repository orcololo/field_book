import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'package:field_book/core/repositories/plant_repository.dart';
import 'package:field_book/core/repositories/session_repository.dart';
import 'package:field_book/models/collection_session.dart';
import 'package:field_book/models/gps_point.dart';
import 'package:field_book/models/plant_category.dart';
import 'package:field_book/models/plant_record.dart';

import '../../test_helpers/isar_test_helper.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

int _seq = 0;
String _uid([String prefix = 's']) => '$prefix-${++_seq}';

/// Sentinel meaning "auto-generate a unique shareCode".
const Object _kAutoCode = Object();

/// Builds a minimal valid [CollectionSession].
///
/// NOTE: Isar 3 treats null as a unique value for [@Index(unique: true)]
/// fields. To avoid constraint violations, each session receives a unique
/// auto-generated shareCode unless [shareCode] is explicitly overridden.
/// Pass `shareCode: null` only when you need a null shareCode — and only
/// ONE such session per test.
CollectionSession _makeSession({
  String? uuid,
  String? tripName,
  DateTime? startDate,
  bool isArchived = false,
  List<String> sharedWith = const [],
  List<String> teamMembers = const [],
  String? notes,
  Object? shareCode = _kAutoCode,
}) {
  final s = CollectionSession()
    ..uuid = uuid ?? _uid('uuid')
    ..tripName = tripName ?? 'Trip ${_uid('name')}'
    ..startDate = startDate ?? DateTime(2025, 1, (_seq % 28) + 1)
    ..isArchived = isArchived
    ..sharedWith = List.of(sharedWith)
    ..teamMembers = List.of(teamMembers)
    ..notes = notes
    ..createdAt = DateTime.now();

  s.shareCode = identical(shareCode, _kAutoCode)
      ? 'SC${_seq.toString().padLeft(4, '0')}'
      : shareCode as String?;

  return s;
}

/// Builds a minimal valid [PlantRecord] with a unique registryIdentifier.
const Object _kAutoPlantId = Object();

PlantRecord _makePlant({
  String? uuid,
  String? sessionId,
  Object? registryIdentifier = _kAutoPlantId,
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

  if (sessionId != null) p.sessionId = sessionId;

  p.registryIdentifier = identical(registryIdentifier, _kAutoPlantId)
      ? 'PLT-${_uid('pid')}'
      : registryIdentifier as String?;

  return p;
}

// ---------------------------------------------------------------------------
void main() {
  late Isar isar;
  late Directory dir;
  late SessionRepository repo;

  setUp(() async {
    (isar, dir) = await openTestIsar();
    repo = SessionRepository();
  });

  tearDown(() async => closeTestIsar(isar, dir));

  // ---------------------------------------------------------------------------
  group('save + getById', () {
    test('persists a new session and getById retrieves it', () async {
      final s = _makeSession(uuid: _uid(), tripName: 'Amazon 2025');
      await repo.save(s);

      final found = await repo.getById(s.id);
      expect(found, isNotNull);
      expect(found!.uuid, s.uuid);
      expect(found.tripName, 'Amazon 2025');
    });

    test('updates an existing session in place', () async {
      final s = _makeSession(uuid: _uid());
      await repo.save(s);
      s.tripName = 'Updated Trip';
      await repo.save(s);

      expect((await repo.getById(s.id))!.tripName, 'Updated Trip');
    });

    test('persists teamMembers and notes', () async {
      final s = _makeSession(
        uuid: _uid(),
        teamMembers: ['Alice', 'Bob'],
        notes: 'Wet season',
      );
      await repo.save(s);

      final found = await repo.getById(s.id);
      expect(found!.teamMembers, containsAll(['Alice', 'Bob']));
      expect(found.notes, 'Wet season');
    });
  });

  // ---------------------------------------------------------------------------
  group('getByUuid', () {
    test('returns session matching uuid', () async {
      final uuid = _uid('u');
      await repo.save(_makeSession(uuid: uuid));
      expect((await repo.getByUuid(uuid))!.uuid, uuid);
    });

    test('returns null for unknown uuid', () async {
      expect(await repo.getByUuid('no-such-uuid'), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  group('getByShareCode', () {
    test('finds session by exact share code', () async {
      final s = _makeSession(uuid: _uid(), shareCode: 'ABCXYZ');
      await repo.save(s);
      final found = await repo.getByShareCode('ABCXYZ');
      expect(found, isNotNull);
      expect(found!.uuid, s.uuid);
    });

    test('returns null for unknown share code', () async {
      expect(await repo.getByShareCode('XXXXXX'), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  group('delete', () {
    test('removes the session by id', () async {
      final s = _makeSession(uuid: _uid());
      await repo.save(s);
      await repo.delete(s.id);
      expect(await repo.getById(s.id), isNull);
    });

    test('throws when session has associated plants', () async {
      final s = _makeSession(uuid: _uid());
      await repo.save(s);

      // Associate a plant with this session via PlantRepository.
      final plantRepo = PlantRepository();
      final plant = _makePlant(sessionId: s.uuid);
      await plantRepo.save(plant);

      await expectLater(
        repo.delete(s.id),
        throwsA(isA<Exception>()),
      );

      // Session should still exist.
      expect(await repo.getById(s.id), isNotNull);
    });

    test('throws when session does not exist', () async {
      await expectLater(
        repo.delete(99999),
        throwsA(isA<Exception>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  group('getAll', () {
    setUp(() async {
      await repo.save(_makeSession(uuid: _uid(), isArchived: false));
      await repo.save(_makeSession(uuid: _uid(), isArchived: false));
      await repo.save(_makeSession(uuid: _uid(), isArchived: true));
    });

    test('returns all sessions when no filter', () async {
      expect((await repo.getAll()).length, 3);
    });

    test('filters active sessions (isArchived: false)', () async {
      final results = await repo.getAll(isArchived: false);
      expect(results.length, 2);
      expect(results.every((s) => !s.isArchived), isTrue);
    });

    test('filters archived sessions (isArchived: true)', () async {
      final results = await repo.getAll(isArchived: true);
      expect(results.length, 1);
      expect(results.first.isArchived, isTrue);
    });

    test('sorted by startDate descending', () async {
      // Add sessions with distinct dates.
      final older = _makeSession(
        uuid: _uid(),
        startDate: DateTime(2020, 1, 1),
      );
      final newer = _makeSession(
        uuid: _uid(),
        startDate: DateTime(2024, 6, 1),
      );
      await repo.save(older);
      await repo.save(newer);

      final all = await repo.getAll();
      // The newest should appear first.
      expect(all.first.startDate.isAfter(all.last.startDate), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  group('getPaginated', () {
    setUp(() async {
      for (var i = 0; i < 5; i++) {
        await repo.save(_makeSession(
          uuid: _uid(),
          isArchived: false,
          startDate: DateTime(2024, 1, i + 1),
        ));
      }
      for (var i = 0; i < 3; i++) {
        await repo.save(_makeSession(
          uuid: _uid(),
          isArchived: true,
          startDate: DateTime(2023, 1, i + 1),
        ));
      }
    });

    test('returns all 8 when no filter', () async {
      expect((await repo.getPaginated(limit: 100)).length, 8);
    });

    test('filters active (isArchived: false)', () async {
      expect((await repo.getPaginated(isArchived: false, limit: 100)).length, 5);
    });

    test('filters archived (isArchived: true)', () async {
      expect((await repo.getPaginated(isArchived: true, limit: 100)).length, 3);
    });

    test('respects limit', () async {
      expect((await repo.getPaginated(limit: 2)).length, 2);
    });

    test('respects offset', () async {
      final page1 = await repo.getPaginated(offset: 0, limit: 3);
      final page2 = await repo.getPaginated(offset: 3, limit: 3);
      expect(page1.length, 3);
      expect(page2.length, 3);
      // No overlap.
      final ids1 = page1.map((s) => s.id).toSet();
      final ids2 = page2.map((s) => s.id).toSet();
      expect(ids1.intersection(ids2), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('generateShareCode', () {
    test('returns a 6-character alphanumeric code', () async {
      final code = await repo.generateShareCode();
      expect(code, hasLength(6));
      expect(RegExp(r'^[A-Z0-9]{6}$').hasMatch(code), isTrue);
    });

    test('generated code is not already in use', () async {
      final code = await repo.generateShareCode();
      // Persist it so a second generation must avoid it.
      await repo.save(_makeSession(uuid: _uid(), shareCode: code));
      // Generate again — should not collide.
      final code2 = await repo.generateShareCode();
      expect(code2, isNot(equals(code)));
    });
  });

  // ---------------------------------------------------------------------------
  group('addDeviceToSession', () {
    // FIXME: this is wrong but matches current implementation. See "Deferred follow-ups" in 2026-05-08-phase3-test-foundation.md
    // production bug — Isar deserializes List<String> as a fixed-length
    // list. session.sharedWith.add(deviceId) throws UnsupportedError at
    // runtime. Fix: copy the list in addDeviceToSession:
    //   session.sharedWith = [...session.sharedWith, deviceId];
    test('throws UnsupportedError when adding new device (fixed-length list bug)',
        () async {
      final s = _makeSession(uuid: _uid());
      await repo.save(s);

      await expectLater(
        repo.addDeviceToSession(s.uuid, 'device-A'),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('does not duplicate device id', () async {
      final s = _makeSession(uuid: _uid(), sharedWith: ['device-A']);
      await repo.save(s);

      await repo.addDeviceToSession(s.uuid, 'device-A');

      final updated = await repo.getByUuid(s.uuid);
      expect(updated!.sharedWith.where((d) => d == 'device-A').length, 1);
    });

    test('no-op for unknown session uuid', () async {
      // Should not throw.
      await expectLater(
        repo.addDeviceToSession('no-such-uuid', 'device-Z'),
        completes,
      );
    });
  });

  // ---------------------------------------------------------------------------
  group('getSharedSessions', () {
    test('returns sessions where deviceId is in sharedWith', () async {
      final s1 = _makeSession(uuid: _uid(), sharedWith: ['device-A', 'device-B']);
      final s2 = _makeSession(uuid: _uid(), sharedWith: ['device-B']);
      final s3 = _makeSession(uuid: _uid(), sharedWith: []);
      await repo.save(s1);
      await repo.save(s2);
      await repo.save(s3);

      final shared = await repo.getSharedSessions('device-A');
      expect(shared.length, 1);
      expect(shared.first.uuid, s1.uuid);
    });

    test('returns empty list when no session shares with device', () async {
      await repo.save(_makeSession(uuid: _uid(), sharedWith: ['device-X']));
      expect(await repo.getSharedSessions('device-unknown'), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('archive + unarchive', () {
    test('archive sets isArchived to true', () async {
      final s = _makeSession(uuid: _uid(), isArchived: false);
      await repo.save(s);

      await repo.archive(s.id);

      expect((await repo.getById(s.id))!.isArchived, isTrue);
    });

    test('unarchive sets isArchived to false', () async {
      final s = _makeSession(uuid: _uid(), isArchived: true);
      await repo.save(s);

      await repo.unarchive(s.id);

      expect((await repo.getById(s.id))!.isArchived, isFalse);
    });

    test('archive no-op for unknown id', () async {
      await expectLater(repo.archive(99999), completes);
    });

    test('unarchive no-op for unknown id', () async {
      await expectLater(repo.unarchive(99999), completes);
    });
  });

  // ---------------------------------------------------------------------------
  group('count', () {
    setUp(() async {
      await repo.save(_makeSession(uuid: _uid(), isArchived: false));
      await repo.save(_makeSession(uuid: _uid(), isArchived: false));
      await repo.save(_makeSession(uuid: _uid(), isArchived: true));
    });

    test('counts all sessions', () async {
      expect(await repo.count(), 3);
    });

    test('counts active sessions', () async {
      expect(await repo.count(isArchived: false), 2);
    });

    test('counts archived sessions', () async {
      expect(await repo.count(isArchived: true), 1);
    });
  });

  // ---------------------------------------------------------------------------
  group('search', () {
    setUp(() async {
      await repo.save(_makeSession(uuid: _uid(), tripName: 'Amazon Expedition'));
      await repo.save(_makeSession(uuid: _uid(), tripName: 'Cerrado Survey'));
      await repo.save(_makeSession(uuid: _uid(), tripName: 'atlantic forest hike'));
    });

    test('finds sessions by partial trip name (case-insensitive)', () async {
      final results = await repo.search('amazon');
      expect(results.length, 1);
      expect(results.first.tripName, 'Amazon Expedition');
    });

    test('finds by uppercase query', () async {
      final results = await repo.search('CERRADO');
      expect(results.length, 1);
      expect(results.first.tripName, 'Cerrado Survey');
    });

    test('finds lowercase-stored entry with uppercase query', () async {
      final results = await repo.search('FOREST');
      expect(results.length, 1);
    });

    test('returns empty for no match', () async {
      expect(await repo.search('nonexistenttrip'), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('appendTrackPoint', () {
    test('appends a GPS point and returns updated session', () async {
      final s = _makeSession(uuid: _uid());
      await repo.save(s);

      final point = GpsPoint()
        ..latitude = -3.1
        ..longitude = -60.0
        ..altitude = 80
        ..timestamp = DateTime(2025, 6, 1);

      final updated = await repo.appendTrackPoint(s.uuid, point);

      expect(updated, isNotNull);
      expect(updated!.track.length, 1);
      expect(updated.track.first.latitude, closeTo(-3.1, 0.001));
      expect(updated.track.first.longitude, closeTo(-60.0, 0.001));
    });

    test('appends multiple points sequentially', () async {
      final s = _makeSession(uuid: _uid());
      await repo.save(s);

      final p1 = GpsPoint()
        ..latitude = 1.0
        ..longitude = 2.0
        ..timestamp = DateTime(2025, 1, 1);
      final p2 = GpsPoint()
        ..latitude = 3.0
        ..longitude = 4.0
        ..timestamp = DateTime(2025, 1, 2);

      await repo.appendTrackPoint(s.uuid, p1);
      await repo.appendTrackPoint(s.uuid, p2);

      final result = await repo.getByUuid(s.uuid);
      expect(result!.track.length, 2);
    });

    test('returns null for unknown uuid', () async {
      final point = GpsPoint()
        ..latitude = 0
        ..longitude = 0
        ..timestamp = DateTime.now();

      final result = await repo.appendTrackPoint('no-such-uuid', point);
      expect(result, isNull);
    });
  });
}
