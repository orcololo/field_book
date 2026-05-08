// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mediaUploadServiceHash() =>
    r'49649a24db1517b99f9c193c18581dee7f57ae63';

/// See also [mediaUploadService].
@ProviderFor(mediaUploadService)
final mediaUploadServiceProvider = Provider<MediaUploadService>.internal(
  mediaUploadService,
  name: r'mediaUploadServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mediaUploadServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MediaUploadServiceRef = ProviderRef<MediaUploadService>;
String _$syncServiceHash() => r'3bf41d27da9f56dc295e575344d9b3344fc762b7';

/// See also [syncService].
@ProviderFor(syncService)
final syncServiceProvider = Provider<SyncService>.internal(
  syncService,
  name: r'syncServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SyncServiceRef = ProviderRef<SyncService>;
String _$syncNotifierHash() => r'12ee4db188f59a3671e73909ae2837255a2166b4';

/// Notifier that drives sync and exposes status to the UI.
///
/// Copied from [SyncNotifier].
@ProviderFor(SyncNotifier)
final syncNotifierProvider = NotifierProvider<SyncNotifier, SyncState>.internal(
  SyncNotifier.new,
  name: r'syncNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SyncNotifier = Notifier<SyncState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
