// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsSyncHash() => r'2e0d2e7f59ed6b4fe008eb455db09278431f4890';

/// See also [settingsSync].
@ProviderFor(settingsSync)
final settingsSyncProvider = AutoDisposeProvider<Settings?>.internal(
  settingsSync,
  name: r'settingsSyncProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$settingsSyncHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SettingsSyncRef = AutoDisposeProviderRef<Settings?>;
String _$settingsNotifierHash() => r'c3365a0c4aad8a35d9d3db9d557bc8da66a74ab3';

/// See also [SettingsNotifier].
@ProviderFor(SettingsNotifier)
final settingsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SettingsNotifier, Settings>.internal(
  SettingsNotifier.new,
  name: r'settingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingsNotifier = AutoDisposeAsyncNotifier<Settings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
