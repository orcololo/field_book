import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UploadStatus { pending, uploading, completed, failed }

class UploadItem {
  final String id;
  final String filePath;
  final String type; // 'image' or 'audio'
  final String? plantUuid;
  final UploadStatus status;
  final double progress;
  final String? error;

  UploadItem({
    required this.id,
    required this.filePath,
    required this.type,
    this.plantUuid,
    this.status = UploadStatus.pending,
    this.progress = 0.0,
    this.error,
  });

  UploadItem copyWith({
    UploadStatus? status,
    double? progress,
    String? error,
  }) {
    return UploadItem(
      id: id,
      filePath: filePath,
      type: type,
      plantUuid: plantUuid,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      error: error ?? this.error,
    );
  }
}

class UploadQueueState {
  final List<UploadItem> items;

  const UploadQueueState({this.items = const []});

  int get pendingCount => items
      .where((i) =>
          i.status == UploadStatus.pending ||
          i.status == UploadStatus.uploading)
      .length;
  int get completedCount =>
      items.where((i) => i.status == UploadStatus.completed).length;
  int get failedCount =>
      items.where((i) => i.status == UploadStatus.failed).length;
  bool get hasActive => items.any((i) => i.status == UploadStatus.uploading);
  double get overallProgress {
    if (items.isEmpty) return 0;
    return items.fold(0.0, (sum, i) => sum + i.progress) / items.length;
  }

  UploadQueueState copyWith({List<UploadItem>? items}) {
    return UploadQueueState(items: items ?? this.items);
  }
}

class UploadQueueNotifier extends StateNotifier<UploadQueueState> {
  UploadQueueNotifier() : super(const UploadQueueState());

  void addItem(UploadItem item) {
    // Remove completed items before adding new ones to prevent unbounded growth
    final activeItems = state.items.where((i) => i.status != UploadStatus.completed).toList();
    state = state.copyWith(items: [...activeItems, item]);
  }

  void updateItem(String id,
      {UploadStatus? status, double? progress, String? error}) {
    state = state.copyWith(
      items: state.items.map((item) {
        if (item.id == id) {
          return item.copyWith(status: status, progress: progress, error: error);
        }
        return item;
      }).toList(),
    );
  }

  void removeCompleted() {
    state = state.copyWith(
      items:
          state.items.where((i) => i.status != UploadStatus.completed).toList(),
    );
  }

  void clear() {
    state = const UploadQueueState();
  }
}

final uploadQueueProvider =
    StateNotifierProvider<UploadQueueNotifier, UploadQueueState>(
  (ref) => UploadQueueNotifier(),
);
