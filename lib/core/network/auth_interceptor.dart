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
  final void Function()? onSessionInvalidated;

  AuthInterceptor({
    required Dio dio,
    required TokenStorage tokenStorage,
    this.onSessionInvalidated,
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
      onSessionInvalidated?.call();
      return handler.next(err);
    }

    // Don't retry a request that already went through one refresh cycle
    if (err.requestOptions.extra['_authRetried'] == true) {
      await _tokenStorage.clearTokens();
      onSessionInvalidated?.call();
      return handler.next(err);
    }

    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        await _tokenStorage.clearTokens();
        onSessionInvalidated?.call();
        return handler.next(err);
      }

      // Attempt token refresh using a clean Dio instance to avoid loop
      final refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));
      final response = await refreshDio.post(
        ApiEndpoints.authRefresh,
        data: {'refreshToken': refreshToken},
      );

      final newAccess = response.data['data']['accessToken'] as String;
      // Refresh token is delivered via header, not JSON body.
      final newRefresh = response.headers.value('x-refresh-token');
      if (newRefresh == null || newRefresh.isEmpty) {
        // Server responded but omitted the required header — this is a contract
        // failure, not a transient network error. Invalidate immediately so the
        // user is prompted to re-authenticate rather than silently retaining
        // stale tokens that will keep producing 401s.
        _log.w('Missing X-Refresh-Token header — contract failure, clearing session');
        await _tokenStorage.clearTokens();
        onSessionInvalidated?.call();
        return handler.next(err);
      }
      await _tokenStorage.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );

      _log.d('Token refreshed successfully');

      // Retry the original request exactly once
      final options = err.requestOptions;
      options.extra['_authRetried'] = true;
      options.headers['Authorization'] = 'Bearer $newAccess';
      final retryResponse = await _dio.fetch(options);
      return handler.resolve(retryResponse);
    } catch (e) {
      final isServerRejection = e is DioException &&
          (e.response?.statusCode == 401 || e.response?.statusCode == 403);
      if (isServerRejection) {
        _log.w('Token refresh rejected by server '
            '(${e.response?.statusCode}), clearing session');
        await _tokenStorage.clearTokens();
        onSessionInvalidated?.call();
      } else {
        _log.w('Token refresh failed (network/transient error), '
            'preserving session tokens for next attempt');
      }
      return handler.next(err);
    }
  }
}
