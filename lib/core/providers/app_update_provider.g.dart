// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_update_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$githubDioHash() => r'331b5e073fe0a86414b76e1bb5db223c6912399c';

/// See also [githubDio].
@ProviderFor(githubDio)
final githubDioProvider = Provider<Dio>.internal(
  githubDio,
  name: r'githubDioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$githubDioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GithubDioRef = ProviderRef<Dio>;
String _$appUpdateServiceHash() => r'cdb6db906734ee70805c06ac7fb4a089d4260778';

/// See also [appUpdateService].
@ProviderFor(appUpdateService)
final appUpdateServiceProvider = Provider<AppUpdateService>.internal(
  appUpdateService,
  name: r'appUpdateServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appUpdateServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppUpdateServiceRef = ProviderRef<AppUpdateService>;
String _$appUpdateNotifierHash() => r'd18ffac772f9a9a4c6cb65454bcaa82ec0f18879';

/// See also [AppUpdateNotifier].
@ProviderFor(AppUpdateNotifier)
final appUpdateNotifierProvider =
    NotifierProvider<AppUpdateNotifier, AppUpdateState>.internal(
  AppUpdateNotifier.new,
  name: r'appUpdateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appUpdateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppUpdateNotifier = Notifier<AppUpdateState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
