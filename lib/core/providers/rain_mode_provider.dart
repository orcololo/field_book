import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/settings_service.dart';

part 'rain_mode_provider.g.dart';

@riverpod
class RainModeNotifier extends _$RainModeNotifier {
  @override
  bool build() {
    return ref.watch(settingsNotifierProvider).maybeWhen(
      data: (settings) => settings.rainModeEnabled,
      orElse: () => false,
    );
  }

  Future<void> setEnabled(bool enabled) async {
    if (state == enabled) return;

    state = enabled;
    await ref.read(settingsNotifierProvider.notifier).setRainModeEnabled(enabled);
  }

  Future<void> toggle() async {
    await setEnabled(!state);
  }
}

@riverpod
bool rainModeEnabled(RainModeEnabledRef ref) {
  return ref.watch(rainModeNotifierProvider);
}
