import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import '../providers/auth_provider.dart';
import 'auth_interceptor.dart';
import 'connectivity_interceptor.dart';
import 'token_storage.dart';

part 'api_client.g.dart';

// Configure the API URL at build time:
//   flutter run --dart-define=API_BASE_URL=http://192.168.1.100:3000
//   flutter build apk --dart-define=API_BASE_URL=https://api.fieldbook.app

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) {
  return TokenStorage();
}

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final tokenStorage = ref.read(tokenStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    ConnectivityInterceptor(),
    AuthInterceptor(
      dio: dio,
      tokenStorage: tokenStorage,
      onSessionInvalidated: () =>
          ref.read(authNotifierProvider.notifier).invalidateSession(),
    ),
  ]);

  return dio;
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  return ApiClient(ref.read(dioProvider));
}

/// Thin wrapper around [Dio] to standardize response unwrapping.
///
/// All backend responses are wrapped in `{ success, data, timestamp }` by the
/// TransformInterceptor, so helpers peel off the `data` layer.
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Dio get dio => _dio;

  /// GET request — returns the `data` field from the standard envelope.
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
    );
    return response.data!['data'] as T;
  }

  /// POST request that returns the full Dio [Response], including headers.
  /// Use this for auth endpoints where the refresh token is delivered via
  /// the [X-Refresh-Token] response header rather than the JSON body.
  Future<Response<Map<String, dynamic>>> postFull(
    String path, {
    Object? data,
  }) async {
    return _dio.post<Map<String, dynamic>>(path, data: data);
  }

  /// POST request.
  Future<T> post<T>(
    String path, {
    Object? data,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: data,
    );
    return response.data!['data'] as T;
  }

  /// PATCH request.
  Future<T> patch<T>(
    String path, {
    Object? data,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      path,
      data: data,
    );
    return response.data!['data'] as T;
  }

  /// DELETE request — may return void-like responses (204).
  Future<void> delete(String path) async {
    await _dio.delete(path);
  }

  /// POST request that tolerates 204 No Content responses (e.g., logout).
  Future<void> postVoid(String path, {Object? data}) async {
    await _dio.post<void>(path, data: data);
  }

  /// Multipart file upload.
  Future<T> upload<T>(
    String path, {
    required FormData formData,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );
    return response.data!['data'] as T;
  }
}
