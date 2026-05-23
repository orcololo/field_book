import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../services/app_update_service.dart';

part 'app_update_provider.g.dart';

class AppUpdateState {
  final bool isChecking;
  final AppReleaseInfo? availableRelease;
  final String? errorMessage;

  const AppUpdateState({
    this.isChecking = false,
    this.availableRelease,
    this.errorMessage,
  });

  bool get hasUpdate => availableRelease != null;

  AppUpdateState copyWith({
    bool? isChecking,
    AppReleaseInfo? availableRelease,
    bool clearRelease = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AppUpdateState(
      isChecking: isChecking ?? this.isChecking,
      availableRelease: clearRelease
          ? null
          : availableRelease ?? this.availableRelease,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

@Riverpod(keepAlive: true)
Dio githubDio(Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: AppConfig.githubApiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {'Accept': 'application/vnd.github+json'},
    ),
  );
}

@Riverpod(keepAlive: true)
AppUpdateService appUpdateService(Ref ref) {
  return AppUpdateService(dio: ref.read(githubDioProvider));
}

@Riverpod(keepAlive: true)
class AppUpdateNotifier extends _$AppUpdateNotifier {
  static const _lastCheckKey = 'app_update_last_check_at';
  static const _dismissedVersionKey = 'app_update_dismissed_version';

  @override
  AppUpdateState build() => const AppUpdateState();

  Future<void> checkForUpdates({bool force = false}) async {
    if (state.isChecking) return;

    final prefs = await SharedPreferences.getInstance();
    if (!force && !_shouldAutoCheck(prefs)) return;

    state = state.copyWith(isChecking: true, clearError: true);
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final installed =
          AppVersion.parse(
            '${packageInfo.version}+${packageInfo.buildNumber}',
          ) ??
          AppVersion.parse(packageInfo.version);
      if (installed == null) return;

      final result = await ref
          .read(appUpdateServiceProvider)
          .checkLatestRelease(
            owner: AppConfig.githubReleaseOwner,
            repo: AppConfig.githubReleaseRepo,
            installedVersion: installed,
          );

      final dismissedVersion = prefs.getString(_dismissedVersionKey);
      final release = result.latestRelease;
      await prefs.setString(_lastCheckKey, DateTime.now().toIso8601String());
      state = AppUpdateState(
        availableRelease:
            release != null && release.versionLabel != dismissedVersion
            ? release
            : null,
      );
    } catch (error) {
      state = AppUpdateState(errorMessage: error.toString());
    } finally {
      state = state.copyWith(isChecking: false);
    }
  }

  Future<void> dismissCurrentUpdate() async {
    final release = state.availableRelease;
    if (release == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dismissedVersionKey, release.versionLabel);
    state = state.copyWith(clearRelease: true);
  }

  bool _shouldAutoCheck(SharedPreferences prefs) {
    final raw = prefs.getString(_lastCheckKey);
    if (raw == null) return true;
    final lastCheck = DateTime.tryParse(raw);
    if (lastCheck == null) return true;
    final elapsed = DateTime.now().difference(lastCheck);
    return elapsed.inHours >= AppConfig.updateCheckThrottleHours;
  }
}
