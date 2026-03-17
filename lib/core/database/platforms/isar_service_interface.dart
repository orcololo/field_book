abstract class IsarServiceInterface {
  static IsarServiceInterface get instance {
    throw UnimplementedError('Must be implemented by platform');
  }

  Future<dynamic> get isar;
  
  Future<void> bulkWrite(
    Future<void> Function(dynamic isar) operation,
  );
  
  Future<T> bulkRead<T>(
    Future<T> Function(dynamic isar) operation,
  );
  
  Future<void> close();
  
  Future<void> clearAll();
}
