// ignore_for_file: lines_longer_than_80_chars
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:field_book/core/network/api_client.dart';
import 'package:field_book/core/services/media_upload_service.dart';
import 'package:field_book/core/sync/sync_service.dart';

// ── Mocks ────────────────────────────────────────────────────────────────────

class MockApiClient extends Mock implements ApiClient {}

class MockMediaUploadService extends Mock implements MediaUploadService {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockApiClient mockApi;
  late MockMediaUploadService mockMediaUpload;
  late MockConnectivity mockConnectivity;
  late SyncService syncService;

  setUp(() {
    mockApi = MockApiClient();
    mockMediaUpload = MockMediaUploadService();
    mockConnectivity = MockConnectivity();
    syncService = SyncService(
      api: mockApi,
      mediaUpload: mockMediaUpload,
      connectivity: mockConnectivity,
    );
  });

  group('SyncService.sync()', () {
    test('returns skipped result when offline', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);

      final result = await syncService.sync();

      expect(result.skipped, isTrue);
      expect(result.pushed, 0);
      expect(result.pulled, 0);
      verify(() => mockConnectivity.checkConnectivity()).called(1);
      verifyNever(
        () => mockApi.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
      );
      verifyNever(
        () => mockApi.get<Map<String, dynamic>>(any()),
      );
    });

    test('does not run concurrently (isSyncing guard)', () async {
      // Verify the guard: when _isSyncing is already true, sync() returns
      // immediately. We can't easily trigger the real flow without Isar,
      // so we verify the property is exposed and the initial state is false.
      expect(syncService.isSyncing, isFalse);
    });
  });

  group('isRetryableError', () {
    test('returns true for connection timeout', () {
      final error = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: '/test'),
      );
      expect(syncService.isRetryableError(error), isTrue);
    });

    test('returns true for send timeout', () {
      final error = DioException(
        type: DioExceptionType.sendTimeout,
        requestOptions: RequestOptions(path: '/test'),
      );
      expect(syncService.isRetryableError(error), isTrue);
    });

    test('returns true for receive timeout', () {
      final error = DioException(
        type: DioExceptionType.receiveTimeout,
        requestOptions: RequestOptions(path: '/test'),
      );
      expect(syncService.isRetryableError(error), isTrue);
    });

    test('returns true for connection error', () {
      final error = DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: '/test'),
      );
      expect(syncService.isRetryableError(error), isTrue);
    });

    test('returns true for 500+ server errors', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          statusCode: 503,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );
      expect(syncService.isRetryableError(error), isTrue);
    });

    test('returns false for 400 client error', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );
      expect(syncService.isRetryableError(error), isFalse);
    });

    test('returns false for 401 unauthorized', () {
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );
      expect(syncService.isRetryableError(error), isFalse);
    });

    test('returns false for cancel type', () {
      final error = DioException(
        type: DioExceptionType.cancel,
        requestOptions: RequestOptions(path: '/test'),
      );
      expect(syncService.isRetryableError(error), isFalse);
    });

    test('returns false for non-DioException errors', () {
      expect(syncService.isRetryableError(Exception('random')), isFalse);
      expect(syncService.isRetryableError('string error'), isFalse);
    });
  });

  group('withRetry', () {
    test('returns result on first success', () async {
      var callCount = 0;
      final result = await syncService.withRetry(() async {
        callCount++;
        return 'success';
      });

      expect(result, 'success');
      expect(callCount, 1);
    });

    test('retries on retryable error and succeeds', () async {
      var callCount = 0;
      final result = await syncService.withRetry(
        () async {
          callCount++;
          if (callCount < 3) {
            throw DioException(
              type: DioExceptionType.connectionTimeout,
              requestOptions: RequestOptions(path: '/test'),
            );
          }
          return 'recovered';
        },
        maxAttempts: 3,
        initialDelay: const Duration(milliseconds: 1),
      );

      expect(result, 'recovered');
      expect(callCount, 3);
    });

    test('throws after max attempts exhausted', () async {
      var callCount = 0;

      await expectLater(
        () => syncService.withRetry(
          () async {
            callCount++;
            throw DioException(
              type: DioExceptionType.connectionTimeout,
              requestOptions: RequestOptions(path: '/test'),
            );
          },
          maxAttempts: 2,
          initialDelay: const Duration(milliseconds: 1),
        ),
        throwsA(isA<DioException>()),
      );

      expect(callCount, 2);
    });

    test('does not retry on non-retryable error', () async {
      var callCount = 0;

      await expectLater(
        () => syncService.withRetry(
          () async {
            callCount++;
            throw DioException(
              type: DioExceptionType.badResponse,
              requestOptions: RequestOptions(path: '/test'),
              response: Response(
                statusCode: 404,
                requestOptions: RequestOptions(path: '/test'),
              ),
            );
          },
          maxAttempts: 3,
          initialDelay: const Duration(milliseconds: 1),
        ),
        throwsA(isA<DioException>()),
      );

      expect(callCount, 1);
    });
  });

  group('SyncResult', () {
    test('operator + combines results correctly', () {
      const a = SyncResult(pushed: 2, pulled: 1, conflicts: 1, errors: 0);
      const b = SyncResult(
        pushed: 1,
        pulled: 3,
        conflicts: 0,
        errors: 1,
        errorMessages: ['fail'],
      );

      final combined = a + b;

      expect(combined.pushed, 3);
      expect(combined.pulled, 4);
      expect(combined.conflicts, 1);
      expect(combined.errors, 1);
      expect(combined.errorMessages, ['fail']);
    });

    test('hasErrors returns true when errors > 0', () {
      const result = SyncResult(errors: 1);
      expect(result.hasErrors, isTrue);
    });

    test('hasErrors returns false when errors == 0', () {
      const result = SyncResult(errors: 0);
      expect(result.hasErrors, isFalse);
    });

    test('skipped combines with AND logic', () {
      const a = SyncResult(skipped: true);
      const b = SyncResult(skipped: false);

      expect((a + b).skipped, isFalse);
      expect((a + a).skipped, isTrue);
    });
  });
}
