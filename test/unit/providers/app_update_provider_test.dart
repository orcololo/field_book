import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:field_book/core/providers/app_update_provider.dart';
import 'package:field_book/core/services/app_update_service.dart';

class MockAppUpdateService extends Mock implements AppUpdateService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(const AppVersion(0, 0, 0));
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Folium',
      packageName: 'com.example.field_book',
      version: '1.8.0',
      buildNumber: '8',
      buildSignature: '',
    );
  });

  group('AppUpdateNotifier', () {
    test('does not throttle automatic checks after a failed attempt', () async {
      final service = MockAppUpdateService();
      when(
        () => service.checkLatestRelease(
          owner: any(named: 'owner'),
          repo: any(named: 'repo'),
          installedVersion: any(named: 'installedVersion'),
        ),
      ).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/releases/latest')),
      );

      final container = ProviderContainer(
        overrides: [appUpdateServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      await container
          .read(appUpdateNotifierProvider.notifier)
          .checkForUpdates();
      await container
          .read(appUpdateNotifierProvider.notifier)
          .checkForUpdates();

      verify(
        () => service.checkLatestRelease(
          owner: any(named: 'owner'),
          repo: any(named: 'repo'),
          installedVersion: any(named: 'installedVersion'),
        ),
      ).called(2);
    });

    test('throttles automatic checks after a successful attempt', () async {
      final service = MockAppUpdateService();
      when(
        () => service.checkLatestRelease(
          owner: any(named: 'owner'),
          repo: any(named: 'repo'),
          installedVersion: any(named: 'installedVersion'),
        ),
      ).thenAnswer(
        (_) async => const AppUpdateCheckResult(
          installedVersion: AppVersion(1, 8, 0, build: 8),
          latestRelease: null,
          isUpdateAvailable: false,
        ),
      );

      final container = ProviderContainer(
        overrides: [appUpdateServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      await container
          .read(appUpdateNotifierProvider.notifier)
          .checkForUpdates();
      await container
          .read(appUpdateNotifierProvider.notifier)
          .checkForUpdates();

      verify(
        () => service.checkLatestRelease(
          owner: any(named: 'owner'),
          repo: any(named: 'repo'),
          installedVersion: any(named: 'installedVersion'),
        ),
      ).called(1);
    });
  });
}
