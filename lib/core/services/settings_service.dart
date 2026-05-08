// ignore_for_file: deprecated_member_use

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../models/settings.dart';
import '../database/isar_service.dart';

part 'settings_service.g.dart';

const _uuid = Uuid();

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<Settings> build() async {
    return await _loadSettings();
  }

  Future<Settings> _loadSettings() async {
    final isar = await IsarService.instance.isar;
    var settings = await isar.settings.get(1);

    if (settings == null) {
      // Create default settings
      settings = Settings()
        ..deviceId = _uuid.v4()
        ..deviceName = 'My Device'
        ..createdAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.settings.put(settings!);
      });
    }

    return settings;
  }

  Future<void> updateSettings(Settings settings) async {
    final isar = await IsarService.instance.isar;
    
    await isar.writeTxn(() async {
      await isar.settings.put(settings);
    });

    // Update state
    state = AsyncData(settings);
  }

  // Convenience methods for common updates
  Future<void> setLocale(String localeCode) async {
    final settings = await future;
    settings.localeCode = localeCode;
    await updateSettings(settings);
  }

  Future<void> setMapProvider(MapProvider provider) async {
    final settings = await future;
    settings.mapProvider = provider;
    await updateSettings(settings);
  }

  Future<void> setAutoSaveInterval(int seconds) async {
    final settings = await future;
    settings.autoSaveInterval = seconds;
    await updateSettings(settings);
  }

  Future<void> setPhotoCompressionQuality(int quality) async {
    final settings = await future;
    settings.photoCompressionQuality = quality;
    await updateSettings(settings);
  }

  Future<void> setCloudBackupEnabled(bool enabled) async {
    final settings = await future;
    settings.cloudBackupEnabled = enabled;
    await updateSettings(settings);
  }

  Future<void> setCloudBackupProvider(CloudBackupProvider provider) async {
    final settings = await future;
    settings.cloudBackupProvider = provider;
    await updateSettings(settings);
  }

  Future<void> setRainModeEnabled(bool enabled) async {
    final settings = await future;
    settings.rainModeEnabled = enabled;
    await updateSettings(settings);
  }

  Future<void> setHasCompletedOnboarding(bool completed) async {
    final settings = await future;
    settings.hasCompletedOnboarding = completed;
    await updateSettings(settings);
  }

  Future<void> updateLastCloudBackup() async {
    final settings = await future;
    settings.lastCloudBackup = DateTime.now();
    await updateSettings(settings);
  }

  Future<void> updateLastLocalBackup() async {
    final settings = await future;
    settings.lastLocalBackup = DateTime.now();
    await updateSettings(settings);
  }

  Future<void> setInaturalistCredentials({
    required String? accessToken,
    required String? username,
  }) async {
    final settings = await future;
    settings.inatAccessToken = accessToken?.trim().isEmpty ?? true
        ? null
        : accessToken!.trim();
    settings.inatUsername = username?.trim().isEmpty ?? true
        ? null
        : username!.trim();
    await updateSettings(settings);
  }
}

// Convenient provider for accessing settings synchronously when available
@riverpod
Settings? settingsSync(SettingsSyncRef ref) {
  return ref.watch(settingsNotifierProvider).valueOrNull;
}
