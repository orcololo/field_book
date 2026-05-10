import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/plant_record.dart';
import '../../models/sync_metadata.dart';
import '../database/isar_service.dart';
import 'auth_provider.dart';
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

final conflictRecordsProvider = StreamProvider<List<PlantRecord>>((ref) async* {
  final isar = await IsarService.instance.isar;

  yield await _loadConflictRecords(isar);

  yield* isar.plantRecords.watchLazy().asyncMap(
    (_) => _loadConflictRecords(isar),
  );
});

Future<List<PlantRecord>> _loadConflictRecords(Isar isar) {
  return isar.plantRecords
      .filter()
      .syncMetadata((q) => q.syncStatusEqualTo(SyncStatus.conflict))
      .sortByUpdatedAtDesc()
      .findAll();
}

/// Notifier that drives sync and exposes status to the UI.
@Riverpod(keepAlive: true)
class SyncNotifier extends _$SyncNotifier {
  @override
  SyncState build() {
    _setupAutoSync();
    return const SyncState();
  }

  void _setupAutoSync() {
    final connectivity = Connectivity();

    final sub = connectivity.onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        final authState = ref.read(authNotifierProvider);
        if (authState is AuthAuthenticated) {
          await _syncIfTokensPresent();
        }
      }
    });

    final timer = Timer.periodic(const Duration(minutes: 15), (_) async {
      final authState = ref.read(authNotifierProvider);
      if (authState is AuthAuthenticated) {
        await _syncIfTokensPresent();
      }
    });

    ref.onDispose(() {
      sub.cancel();
      timer.cancel();
    });
  }

  /// Verify tokens still exist before triggering an automatic sync.
  /// If they have been cleared externally (e.g., by AuthInterceptor after a
  /// confirmed server rejection), invalidate the auth state immediately.
  Future<void> _syncIfTokensPresent() async {
    final hasTokens = await ref.read(tokenStorageProvider).hasTokens();
    if (!hasTokens) {
      ref.read(authNotifierProvider.notifier).invalidateSession();
      return;
    }
    sync();
  }

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
