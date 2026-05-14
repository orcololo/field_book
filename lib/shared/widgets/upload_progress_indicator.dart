import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/upload_queue_provider.dart';

/// A compact upload progress indicator shown in the app.
class UploadProgressIndicator extends ConsumerWidget {
  const UploadProgressIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(uploadQueueProvider);

    if (queue.pendingCount == 0 && !queue.hasActive) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.green.shade50,
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              value: queue.overallProgress > 0 ? queue.overallProgress : null,
              strokeWidth: 2,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enviando ${queue.pendingCount} arquivo${queue.pendingCount > 1 ? 's' : ''}...',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: queue.overallProgress > 0
                        ? queue.overallProgress
                        : null,
                    minHeight: 3,
                    backgroundColor: Colors.green.shade100,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (queue.failedCount > 0)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                '${queue.failedCount} falha${queue.failedCount > 1 ? 's' : ''}',
                style: TextStyle(fontSize: 11, color: Colors.red.shade700),
              ),
            ),
        ],
      ),
    );
  }
}
