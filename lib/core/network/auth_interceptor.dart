import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'api_endpoints.dart';
import 'token_storage.dart';

final _log = Logger(printer: PrettyPrinter(methodCount: 0));

/// Interceptor that attaches JWT access tokens to requests and
/// transparently refreshes them on 401 responses.
class AuthInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  AuthInterceptor({
    required Dio dio,
    required TokenStorage tokenStorage,
  })  : _dio = dio,
        _tokenStorage = tokenStorage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for public endpoints
    final publicPaths = [
      ApiEndpoints.authLogin,
      ApiEndpoints.authRegister,
      ApiEndpoints.authGoogle,
      ApiEndpoints.authRefresh,
      ApiEndpoints.health,
    ];
    if (publicPaths.any((p) => options.path.contains(p))) {
      return handler.next(options);
    }

    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Don't retry refresh endpoint itself
    if (err.requestOptions.path.contains(ApiEndpoints.authRefresh)) {
      await _tokenStorage.clearTokens();
      return handler.next(err);
    }

    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        await _tokenStorage.clearTokens();
        return handler.next(err);
      }

      // Attempt token refresh using a clean Dio instance to avoid loop
      final refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));
      final response = await refreshDio.post(
        ApiEndpoints.authRefresh,
        data: {'refreshToken': refreshToken},
      );

      final newAccess = response.data['data']['accessToken'] as String;
      final newRefresh = response.data['data']['refreshToken'] as String;
      await _tokenStorage.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );

      _log.d('Token refreshed successfully');

      // Retry the original request with new token
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $newAccess';
      final retryResponse = await _dio.fetch(options);
      return handler.resolve(retryResponse);
    } catch (e) {
      _log.w('Token refresh failed, clearing tokens');
      await _tokenStorage.clearTokens();
      return handler.next(err);
    }
  }
}
