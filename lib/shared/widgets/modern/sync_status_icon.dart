import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/sync_provider.dart';

// Shows: spinning indicator while syncing, cloud-done when synced, 
// cloud-error with red badge when error, cloud-upload with amber badge when pending
class SyncStatusIcon extends ConsumerWidget {
  const SyncStatusIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (syncState.isSyncing) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colorScheme.primary,
        ),
      );
    }

    if (syncState.lastError != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(Icons.cloud_off_outlined, color: colorScheme.error, size: 22),
          Positioned(
            top: -2, right: -2,
            child: Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: colorScheme.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }

    if (syncState.lastSyncAt != null) {
      return Icon(Icons.cloud_done_outlined, color: colorScheme.primary, size: 22);
    }

    // No sync yet — show neutral cloud
    return Icon(Icons.cloud_outlined, color: colorScheme.onSurfaceVariant, size: 22);
  }
}
