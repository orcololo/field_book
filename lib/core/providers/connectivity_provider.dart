import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reactive connectivity provider that streams the current connectivity state.
/// Returns `true` when the device has any network connection (wifi, mobile, etc).
final isOnlineProvider = StreamProvider<bool>((ref) {
  final connectivity = Connectivity();

  return connectivity.onConnectivityChanged.map(
    (result) => result != ConnectivityResult.none,
  );
});

/// Synchronous provider that returns the last known connectivity state.
/// Defaults to `true` (assume online) until the stream emits.
final isOnlineValueProvider = Provider<bool>((ref) {
  return ref.watch(isOnlineProvider).valueOrNull ?? true;
});
