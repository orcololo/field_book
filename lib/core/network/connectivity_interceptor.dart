import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

/// Interceptor that checks network connectivity before making requests.
/// Throws a [DioException] with [DioExceptionType.connectionError] when offline.
class ConnectivityInterceptor extends Interceptor {
  final Connectivity _connectivity;

  ConnectivityInterceptor({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final result = await _connectivity.checkConnectivity();
    final isOffline = result == ConnectivityResult.none;

    if (isOffline) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'No internet connection',
        ),
      );
    }

    handler.next(options);
  }
}
