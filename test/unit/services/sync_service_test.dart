import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mocktail/mocktail.dart';

import 'package:field_book/core/network/api_client.dart';
import 'package:field_book/core/network/api_endpoints.dart';
import 'package:field_book/core/services/media_upload_service.dart';
import 'package:field_book/core/sync/sync_service.dart';
import 'package:field_book/models/plant_category.dart';
import 'package:field_book/models/plant_record.dart';
import 'package:field_book/models/sync_metadata.dart';

import '../../test_helpers/isar_test_helper.dart';
import '../../test_helpers/mocks.dart';

// ---------------------------------------------------------------------------
// Extra mock classes
// ---------------------------------------------------------------------------

class MockConnectivity extends Mock implements Connectivity {}

class MockMediaUploadService extends Mock implements MediaUploadService {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Response<Map<String, dynamic>> _dioResponse(Map<String, dynamic> data) {
  return Response<Map<String, dynamic>>(
    data: data,
    statusCode: 200,
    requestOptions: RequestOptions(path: ''),
  );
}

PlantRecord _minimalPlant({
  String uuid = 'plant-uuid-1',
  String scientificName = 'Mimosa pudica',
}) {
  return PlantRecord()
    ..uuid = uuid
    ..scientificName = scientificName
    ..scientificNameFts = scientificName.toLowerCase()
    ..commonNameFts = ''
    ..dateCollected = DateTime(2025, 6, 1)
    ..category = PlantCategory.herbs
    ..deviceId = 'device-1'
    ..createdAt = DateTime(2025, 6, 1)
    ..updatedAt = DateTime(2025, 6, 1);
}

// ---------------------------------------------------------------------------

void main() {
  setUpAll(registerCommonFallbacks);

  // ── SyncResult pure logic ──────────────────────────────────────────────────

  group('SyncResult', () {
    test('hasErrors is false when errors == 0', () {
      const r = SyncResult(errors: 0);
      expect(r.hasErrors, isFalse);
    });

    test('hasErrors is true when errors > 0', () {
      const r = SyncResult(errors: 1);
      expect(r.hasErrors, isTrue);
    });

    test('operator+ accumulates all numeric fields', () {
      const a = SyncResult(pushed: 2, pulled: 3, conflicts: 1, errors: 0);
      const b = SyncResult(pushed: 1, pulled: 0, conflicts: 0, errors: 1);
      final c = a + b;
      expect(c.pushed, 3);
      expect(c.pulled, 3);
      expect(c.conflicts, 1);
      expect(c.errors, 1);
    });

    test('operator+ concatenates errorMessages', () {
      const a = SyncResult(errorMessages: ['err-a']);
      const b = SyncResult(errorMessages: ['err-b', 'err-c']);
      final c = a + b;
      expect(c.errorMessages, ['err-a', 'err-b', 'err-c']);
    });

    test('operator+ with two empty results is empty', () {
      const a = SyncResult();
      const b = SyncResult();
      final c = a + b;
      expect(c.pushed, 0);
      expect(c.pulled, 0);
      expect(c.conflicts, 0);
      expect(c.errors, 0);
      expect(c.errorMessages, isEmpty);
    });
  });

  // ── isSyncing getter ───────────────────────────────────────────────────────

  group('isSyncing', () {
    test('is false before any sync call', () {
      final svc = SyncService(
        api: ApiClient(MockDio()),
        mediaUpload: MockMediaUploadService(),
        connectivity: MockConnectivity(),
      );
      expect(svc.isSyncing, isFalse);
    });
  });

  // ── sync() offline guard ───────────────────────────────────────────────────

  group('sync() offline', () {
    late MockConnectivity mockConn;
    late SyncService svc;

    setUp(() {
      mockConn = MockConnectivity();
      svc = SyncService(
        api: ApiClient(MockDio()),
        mediaUpload: MockMediaUploadService(),
        connectivity: mockConn,
      );
    });

    test('returns empty SyncResult when connectivity is none', () async {
      when(
        () => mockConn.checkConnectivity(),
      ).thenAnswer((_) async => ConnectivityResult.none);

      final result = await svc.sync();
      expect(result.pushed, 0);
      expect(result.pulled, 0);
      expect(result.errors, 0);
    });
  });

  // ── sync() with real Isar + mocked network ─────────────────────────────────

  group('sync() with Isar', () {
    late MockConnectivity mockConn;
    late MockDio mockDio;
    late SyncService svc;
    late Isar _isar;
    late Directory _dir;

    setUp(() async {
      (_isar, _dir) = await openTestIsar();
      mockConn = MockConnectivity();
      mockDio = MockDio();
      svc = SyncService(
        api: ApiClient(mockDio),
        mediaUpload: MockMediaUploadService(),
        connectivity: mockConn,
      );

      when(
        () => mockConn.checkConnectivity(),
      ).thenAnswer((_) async => ConnectivityResult.wifi);
    });

    tearDown(() => closeTestIsar(_isar, _dir));

    test(
      'returns 0 pushed/pulled when DB is empty and pull returns empty lists',
      () async {
        // Mock the GET /sync/pull endpoint
        when(
          () => mockDio.get<Map<String, dynamic>>(
            ApiEndpoints.syncPull,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => _dioResponse({
            'data': {'registries': [], 'sessions': [], 'hasMore': false},
          }),
        );

        final result = await svc.sync(deviceId: 'test-device');

        expect(result.pushed, 0);
        expect(result.pulled, 0);
        expect(result.errors, 0);
      },
    );

    test('returns error SyncResult when pull API throws', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          ApiEndpoints.syncPull,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(Exception('network error'));

      final result = await svc.sync(deviceId: 'test-device');

      expect(result.errors, 1);
      expect(result.errorMessages.first, contains('network error'));
    });
  });

  // ── buildPlantConflictLocalData ────────────────────────────────────────────

  group('buildPlantConflictLocalData', () {
    late SyncService svc;

    setUp(() {
      svc = SyncService(
        api: ApiClient(MockDio()),
        mediaUpload: MockMediaUploadService(),
        connectivity: MockConnectivity(),
      );
    });

    test('includes uuid, serverId, syncVersion, updatedAt', () {
      final plant = _minimalPlant();
      plant.syncMetadata
        ..serverId = 'server-abc'
        ..syncVersion = 5;

      final data = svc.buildPlantConflictLocalData(plant);

      expect(data['uuid'], 'plant-uuid-1');
      expect(data['_id'], 'server-abc');
      expect(data['syncVersion'], 5);
      expect(data['updatedAt'], isA<String>());
    });

    test('includes scientificName from plant', () {
      final plant = _minimalPlant(scientificName: 'Cecropia pachystachya');
      final data = svc.buildPlantConflictLocalData(plant);
      expect(data['scientificName'], 'Cecropia pachystachya');
    });

    test('localModifiedAt falls back to updatedAt when not set', () {
      final plant = _minimalPlant();
      plant.updatedAt = DateTime(2025, 7, 15);

      final data = svc.buildPlantConflictLocalData(plant);

      // localModifiedAt not set → should equal updatedAt
      expect(data['localModifiedAt'], plant.updatedAt.toIso8601String());
    });

    test('uses localModifiedAt when set on syncMetadata', () {
      final plant = _minimalPlant();
      final modified = DateTime(2025, 8, 1);
      plant.syncMetadata.localModifiedAt = modified;

      final data = svc.buildPlantConflictLocalData(plant);

      expect(data['localModifiedAt'], modified.toIso8601String());
    });
  });
}
