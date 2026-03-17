import 'isar_service_interface.dart';

class IsarService extends IsarServiceInterface {
  static IsarService? _instance;

  IsarService._();

  static IsarService get instance {
    _instance ??= IsarService._();
    return _instance!;
  }

  @override
  Future<dynamic> get isar async {
    throw UnsupportedError('Isar database is not supported on web');
  }

  @override
  Future<void> bulkWrite(
    Future<void> Function(dynamic isar) operation,
  ) async {
    throw UnsupportedError('Isar database is not supported on web');
  }

  @override
  Future<T> bulkRead<T>(
    Future<T> Function(dynamic isar) operation,
  ) async {
    throw UnsupportedError('Isar database is not supported on web');
  }

  @override
  Future<void> close() async {
    // No-op for web
  }

  @override
  Future<void> clearAll() async {
    throw UnsupportedError('Isar database is not supported on web');
  }
}
