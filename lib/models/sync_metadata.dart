import 'package:isar/isar.dart';

part 'sync_metadata.g.dart';

enum SyncStatus {
  pending,
  synced,
  conflict,
  error,
}

@embedded
class SyncMetadata {
  String? serverId;
  DateTime? lastSyncedAt;
  DateTime? localModifiedAt;
  String? conflictData;
  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.pending;
  String? lastPushedHash;
  int syncVersion = 0;

  SyncMetadata();
}
