// ignore_for_file: deprecated_member_use

import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/collection_session.dart';
import '../../models/gps_point.dart';
import '../../models/plant_record.dart';
import '../database/isar_service.dart';
import 'dart:math';

part 'session_repository.g.dart';

@riverpod
SessionRepository sessionRepository(SessionRepositoryRef ref) {
  return SessionRepository();
}

class SessionRepository {
  static final _log = Logger(printer: PrettyPrinter(methodCount: 2));
  Future<Isar> get _isar => IsarService.instance.isar;
  final _random = Random();

  // Create or update session
  Future<void> save(CollectionSession session) async {
    final isar = await _isar;

    await isar.writeTxn(() async {
      await isar.collectionSessions.put(session);
    });
  }

  // Get by ID
  Future<CollectionSession?> getById(int id) async {
    final isar = await _isar;
    return await isar.collectionSessions.get(id);
  }

  // Get by UUID
  Future<CollectionSession?> getByUuid(String uuid) async {
    final isar = await _isar;
    return await isar.collectionSessions.filter().uuidEqualTo(uuid).findFirst();
  }

  // Get by share code
  Future<CollectionSession?> getByShareCode(String shareCode) async {
    final isar = await _isar;
    return await isar.collectionSessions
        .filter()
        .shareCodeEqualTo(shareCode)
        .findFirst();
  }

  // Delete
  Future<void> delete(int id) async {
    try {
      final isar = await _isar;

      // Get session UUID first
      final session = await isar.collectionSessions.get(id);
      if (session == null) {
        throw Exception('Session not found');
      }

      // Check if session has associated plants
      final plantsCount = await isar.plantRecords
          .filter()
          .sessionIdEqualTo(session.uuid)
          .count();

      if (plantsCount > 0) {
        throw Exception(
          'Cannot delete session: $plantsCount plant(s) are associated with it. '
          'Please delete or reassign the plants first.',
        );
      }

      await isar.writeTxn(() async {
        await isar.collectionSessions.delete(id);
      });
    } catch (e, stackTrace) {
      _log.e('Error deleting session', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Get all sessions
  Future<List<CollectionSession>> getAll({bool? isArchived}) async {
    final isar = await _isar;

    if (isArchived != null) {
      return await isar.collectionSessions
          .filter()
          .isArchivedEqualTo(isArchived)
          .sortByStartDateDesc()
          .findAll();
    } else {
      return await isar.collectionSessions
          .where()
          .sortByStartDateDesc()
          .findAll();
    }
  }

  // Get paginated sessions
  Future<List<CollectionSession>> getPaginated({
    int offset = 0,
    int limit = 20,
    bool? isArchived,
  }) async {
    final isar = await _isar;

    if (isArchived != null) {
      return await isar.collectionSessions
          .filter()
          .isArchivedEqualTo(isArchived)
          .sortByStartDateDesc()
          .offset(offset)
          .limit(limit)
          .findAll();
    } else {
      return await isar.collectionSessions
          .where()
          .sortByStartDateDesc()
          .offset(offset)
          .limit(limit)
          .findAll();
    }
  }

  // Generate unique 6-character share code
  Future<String> generateShareCode() async {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    const maxAttempts = 10;

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      final code = List.generate(
        6,
        (index) => chars[_random.nextInt(chars.length)],
      ).join();

      // Check if code already exists by querying the database
      final existing = await getByShareCode(code);
      if (existing == null) {
        return code;
      }
    }

    throw Exception(
      'Failed to generate unique share code after $maxAttempts attempts',
    );
  }

  // Add device to session's shared list
  Future<void> addDeviceToSession(String sessionUuid, String deviceId) async {
    final session = await getByUuid(sessionUuid);

    if (session == null) return;

    if (!session.sharedWith.contains(deviceId)) {
      session.sharedWith.add(deviceId);
      await save(session);
    }
  }

  // Get sessions shared with device
  Future<List<CollectionSession>> getSharedSessions(String deviceId) async {
    final allSessions = await getAll();

    return allSessions
        .where((session) => session.sharedWith.contains(deviceId))
        .toList();
  }

  // Archive session
  Future<void> archive(int id) async {
    final session = await getById(id);
    if (session == null) return;

    session.isArchived = true;
    await save(session);
  }

  // Unarchive session
  Future<void> unarchive(int id) async {
    final session = await getById(id);
    if (session == null) return;

    session.isArchived = false;
    await save(session);
  }

  // Count sessions
  Future<int> count({bool? isArchived}) async {
    final isar = await _isar;

    if (isArchived != null) {
      return await isar.collectionSessions
          .filter()
          .isArchivedEqualTo(isArchived)
          .count();
    } else {
      return await isar.collectionSessions.count();
    }
  }

  // Search sessions by name
  Future<List<CollectionSession>> search(String query) async {
    final isar = await _isar;
    final lowerQuery = query.toLowerCase();

    return await isar.collectionSessions
        .filter()
        .tripNameContains(lowerQuery, caseSensitive: false)
        .sortByStartDateDesc()
        .findAll();
  }

  Future<CollectionSession?> appendTrackPoint(String sessionUuid, GpsPoint point) async {
    final isar = await _isar;
    CollectionSession? updatedSession;

    await isar.writeTxn(() async {
      final session = await isar.collectionSessions
          .filter()
          .uuidEqualTo(sessionUuid)
          .findFirst();

      if (session == null) {
        return;
      }

      session.track = [...session.track, point];
      await isar.collectionSessions.put(session);
      updatedSession = session;
    });

    return updatedSession;
  }
}
