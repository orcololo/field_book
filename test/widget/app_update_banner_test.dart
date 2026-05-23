import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:field_book/core/providers/app_update_provider.dart';
import 'package:field_book/core/providers/connectivity_provider.dart';
import 'package:field_book/core/services/app_update_service.dart';
import 'package:field_book/shared/widgets/app_update_banner.dart';

class MockAppUpdateService extends Mock implements AppUpdateService {}

void main() {
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

  testWidgets('shows update message and actions when release is available', (
    tester,
  ) async {
    final release = AppReleaseInfo(
      version: const AppVersion(1, 8, 1, build: 9),
      versionLabel: 'v1.8.1+9',
      releaseUrl: Uri.parse(
        'https://github.com/orcololo/field_book/releases/tag/v1.8.1',
      ),
      downloadUrl: Uri.parse(
        'https://github.com/orcololo/field_book/releases/download/v1.8.1/folium.apk',
      ),
    );
    var didOpen = false;
    var didDismiss = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TestableAppUpdateBanner(
            release: release,
            onOpen: () => didOpen = true,
            onDismiss: () => didDismiss = true,
          ),
        ),
      ),
    );

    expect(find.textContaining('v1.8.1+9'), findsOneWidget);
    expect(find.byIcon(Icons.system_update_alt), findsOneWidget);

    await tester.tap(find.text('Baixar'));
    await tester.tap(find.text('Depois'));

    expect(didOpen, isTrue);
    expect(didDismiss, isTrue);
  });

  testWidgets('checks for updates when connectivity returns', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    expect(defaultTargetPlatform, TargetPlatform.android);

    final onlineProvider = StateProvider<bool>((ref) => false);
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
      overrides: [
        isOnlineValueProvider.overrideWith((ref) => ref.watch(onlineProvider)),
        appUpdateServiceProvider.overrideWithValue(service),
      ],
    );
    addTearDown(container.dispose);
    expect(container.read(isOnlineValueProvider), isFalse);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: AppUpdateBanner())),
      ),
    );
    await tester.pump();

    verifyNever(
      () => service.checkLatestRelease(
        owner: any(named: 'owner'),
        repo: any(named: 'repo'),
        installedVersion: any(named: 'installedVersion'),
      ),
    );

    container.read(onlineProvider.notifier).state = true;
    expect(container.read(isOnlineValueProvider), isTrue);
    await tester.pumpAndSettle();

    verify(
      () => service.checkLatestRelease(
        owner: any(named: 'owner'),
        repo: any(named: 'repo'),
        installedVersion: any(named: 'installedVersion'),
      ),
    ).called(1);
    debugDefaultTargetPlatformOverride = null;
  });
}
