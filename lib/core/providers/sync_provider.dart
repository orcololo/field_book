import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/api_client.dart';
import '../services/media_upload_service.dart';
import '../sync/sync_service.dart';

part 'sync_provider.g.dart';

@Riverpod(keepAlive: true)
MediaUploadService mediaUploadService(Ref ref) {
  return MediaUploadService(api: ref.read(apiClientProvider));
}

@Riverpod(keepAlive: true)
SyncService syncService(Ref ref) {
  return SyncService(
    api: ref.read(apiClientProvider),
    mediaUpload: ref.read(mediaUploadServiceProvider),
  );
}

/// Notifier that drives sync and exposes status to the UI.
@Riverpod(keepAlive: true)
class SyncNotifier extends _$SyncNotifier {
  @override
  SyncState build() => const SyncState();

  Future<void> sync({String? deviceId}) async {
    if (state.isSyncing) return;

    state = state.copyWith(isSyncing: true, lastError: null);
    try {
      final result = await ref.read(syncServiceProvider).sync(deviceId: deviceId);
      state = state.copyWith(
        isSyncing: false,
        lastResult: result,
        lastSyncAt: DateTime.now(),
        lastError: result.hasErrors ? result.errorMessages.first : null,
      );
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        lastError: e.toString(),
      );
    }
  }
}

class SyncState {
  final bool isSyncing;
  final SyncResult? lastResult;
  final DateTime? lastSyncAt;
  final String? lastError;

  const SyncState({
    this.isSyncing = false,
    this.lastResult,
    this.lastSyncAt,
    this.lastError,
  });

  SyncState copyWith({
    bool? isSyncing,
    SyncResult? lastResult,
    DateTime? lastSyncAt,
    String? lastError,
  }) {
    return SyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      lastResult: lastResult ?? this.lastResult,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      lastError: lastError,
    );
  }
}
