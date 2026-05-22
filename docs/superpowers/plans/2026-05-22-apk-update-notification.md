# APK Update Notification Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Notify Flutter app users when a newer Android APK is available in GitHub Releases and give them a safe way to open the download/release page.

**Architecture:** Add a small update-check subsystem in `lib/core/services/` and `lib/core/providers/`, backed by GitHub Releases metadata and the installed app version. Surface the result through a global banner in `MaterialApp.builder` plus a manual check in Settings > About. Keep the app offline-first by treating network failures as non-blocking and by caching dismiss/check metadata with `SharedPreferences` instead of Isar schema changes.

**Tech Stack:** Flutter, Riverpod codegen, Dio, package_info_plus, shared_preferences, url_launcher, flutter_test, mocktail.

---

## Current Context

- The Flutter app version is currently declared in `pubspec.yaml` as `1.8.0+8`.
- `SettingsScreen` currently hardcodes `applicationVersion: '1.8.0'` in the About dialog.
- Global app banners already live in `lib/main_mobile.dart` inside `MaterialApp.builder` (`ConnectivityBanner`, `UploadProgressIndicator`).
- Network API wrappers in `lib/core/network/api_client.dart` are backend-envelope specific, so GitHub should use a separate raw Dio client instead of `ApiClient`.
- `AppConfig` already centralizes `--dart-define` values; GitHub owner/repo should be added there.
- No existing GitHub issue matched this feature; tracking issue: `orcololo/field_book#9`.

## Design Decisions

1. **Recommended source:** direct GitHub Releases API for public releases.
   - Endpoint: `https://api.github.com/repos/{owner}/{repo}/releases/latest`.
   - Configured through `--dart-define=GITHUB_RELEASE_OWNER=orcololo` and `--dart-define=GITHUB_RELEASE_REPO=field_book` with sane defaults.
   - If releases are private later, replace only the release-fetch adapter with a backend proxy endpoint.

2. **Version comparison:** compare installed `PackageInfo.version` and `PackageInfo.buildNumber` against `tag_name` from GitHub.
   - Accepted tag formats: `v1.8.1`, `1.8.1`, `v1.8.1+9`, `1.8.1+9`.
   - A newer semantic version wins over build number.
   - If semantic version is equal, higher build number is newer.
   - Prerelease or draft releases are ignored.

3. **APK URL resolution:** prefer the first release asset ending with `.apk`; if none exists, open the release `html_url`.
   - Only launch `https` URLs with GitHub-owned hosts (`github.com` or `objects.githubusercontent.com`) to avoid malicious URL injection from malformed metadata.
   - Use `launchUrl(..., mode: LaunchMode.externalApplication)`; do not request Android install permissions or install APKs in-app.

4. **User experience:** non-blocking global banner + manual Settings check.
   - Global banner appears only when an update is available, the device is online, and the user has not dismissed that remote version.
   - Actions: download/open release and dismiss for this version.
   - Settings > About shows installed version dynamically and adds a tile: "Check for updates" / "Verificar atualizacoes".

5. **State persistence:** use `SharedPreferences` for non-domain app-update metadata.
   - `lastUpdateCheckAt`: ISO timestamp to throttle automatic checks.
   - `dismissedUpdateVersion`: remote version string dismissed by the user.
   - This avoids modifying `Settings` Isar schema and avoids `settings.g.dart` changes.

## Files To Create Or Modify

### Create

- `lib/core/services/app_update_service.dart`
  - Fetches GitHub release JSON, parses version/assets, compares versions, validates URLs.
- `lib/core/providers/app_update_provider.dart`
  - Riverpod state notifier for automatic/manual update checks and dismissal.
- `lib/shared/widgets/app_update_banner.dart`
  - Global Material banner shown when an update is available.
- `test/unit/services/app_update_service_test.dart`
  - Pure/service tests for version parsing, comparison, release parsing, and failures.
- `test/widget/app_update_banner_test.dart`
  - Widget tests for banner actions and hidden state.

### Modify

- `pubspec.yaml`
  - Add `package_info_plus` dependency.
- `lib/core/config/app_config.dart`
  - Add GitHub owner/repo/API URL dart-defines and update-check throttle constant.
- `lib/main_mobile.dart`
  - Insert `AppUpdateBanner` into the existing global builder.
- `lib/features/settings/screens/settings_screen.dart`
  - Replace hardcoded About version with dynamic package version.
  - Add manual update-check tile in About section.
- `lib/l10n/app_en.arb`
  - Add English strings.
- `lib/l10n/app_pt.arb`
  - Add Portuguese strings.
- `lib/l10n/app_es.arb`
  - Add Spanish strings.
- Generated after implementation:
  - `lib/core/providers/app_update_provider.g.dart`
  - `lib/core/services/settings_service.g.dart` only if provider names force regeneration of adjacent files; do not edit generated files manually.
  - `lib/l10n/app_localizations*.dart` through Flutter l10n generation.

---

## Task 1: Add App Update Domain Types And Version Logic

**Files:**

- Create: `field_book/lib/core/services/app_update_service.dart`
- Test: `field_book/test/unit/services/app_update_service_test.dart`

- [ ] **Step 1: Write failing tests for version parsing and comparison**

Add these tests to `test/unit/services/app_update_service_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';

import 'package:field_book/core/services/app_update_service.dart';

void main() {
  group('AppVersion', () {
    test('parses semantic versions with optional v prefix and build number', () {
      expect(AppVersion.parse('v1.8.1+9'), const AppVersion(1, 8, 1, build: 9));
      expect(AppVersion.parse('1.8.1'), const AppVersion(1, 8, 1));
      expect(AppVersion.parse('v2.0.0'), const AppVersion(2, 0, 0));
    });

    test('returns null for malformed versions', () {
      expect(AppVersion.parse('release-android'), isNull);
      expect(AppVersion.parse('1.8'), isNull);
      expect(AppVersion.parse(''), isNull);
    });

    test('compares semantic version before build number', () {
      expect(const AppVersion(1, 8, 1).isNewerThan(const AppVersion(1, 8, 0, build: 99)), isTrue);
      expect(const AppVersion(1, 8, 0, build: 9).isNewerThan(const AppVersion(1, 8, 0, build: 8)), isTrue);
      expect(const AppVersion(1, 8, 0, build: 8).isNewerThan(const AppVersion(1, 8, 0, build: 8)), isFalse);
      expect(const AppVersion(1, 7, 9, build: 99).isNewerThan(const AppVersion(1, 8, 0, build: 1)), isFalse);
    });
  });
}
```

- [ ] **Step 2: Run tests and verify RED**

Run:

```bash
cd /Users/orcola/Projetos/Herbario/fieldBook/field_book
flutter test test/unit/services/app_update_service_test.dart
```

Expected: FAIL because `app_update_service.dart` and `AppVersion` do not exist.

- [ ] **Step 3: Implement minimal version type**

Create `lib/core/services/app_update_service.dart` with:

```dart
import 'package:dio/dio.dart';

class AppVersion {
  final int major;
  final int minor;
  final int patch;
  final int build;

  const AppVersion(this.major, this.minor, this.patch, {this.build = 0});

  static final RegExp _pattern = RegExp(r'^v?(\d+)\.(\d+)\.(\d+)(?:\+(\d+))?$');

  static AppVersion? parse(String value) {
    final match = _pattern.firstMatch(value.trim());
    if (match == null) return null;
    return AppVersion(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
      build: int.tryParse(match.group(4) ?? '') ?? 0,
    );
  }

  bool isNewerThan(AppVersion other) {
    if (major != other.major) return major > other.major;
    if (minor != other.minor) return minor > other.minor;
    if (patch != other.patch) return patch > other.patch;
    return build > other.build;
  }

  @override
  bool operator ==(Object other) {
    return other is AppVersion &&
        other.major == major &&
        other.minor == minor &&
        other.patch == patch &&
        other.build == build;
  }

  @override
  int get hashCode => Object.hash(major, minor, patch, build);

  @override
  String toString() => build > 0 ? '$major.$minor.$patch+$build' : '$major.$minor.$patch';
}

class AppReleaseInfo {
  final AppVersion version;
  final String versionLabel;
  final Uri releaseUrl;
  final Uri downloadUrl;
  final String? releaseName;
  final String? body;

  const AppReleaseInfo({
    required this.version,
    required this.versionLabel,
    required this.releaseUrl,
    required this.downloadUrl,
    this.releaseName,
    this.body,
  });
}

class AppUpdateCheckResult {
  final AppVersion installedVersion;
  final AppReleaseInfo? latestRelease;
  final bool isUpdateAvailable;

  const AppUpdateCheckResult({
    required this.installedVersion,
    required this.latestRelease,
    required this.isUpdateAvailable,
  });
}

class AppUpdateService {
  final Dio _dio;

  AppUpdateService({required Dio dio}) : _dio = dio;
}
```

- [ ] **Step 4: Run tests and verify GREEN**

Run:

```bash
flutter test test/unit/services/app_update_service_test.dart
```

Expected: PASS for `AppVersion` tests.

---

## Task 2: Fetch And Parse GitHub Releases

**Files:**

- Modify: `field_book/lib/core/services/app_update_service.dart`
- Test: `field_book/test/unit/services/app_update_service_test.dart`

- [ ] **Step 1: Add failing tests for release parsing**

Add this import at the top of the same test file:

```dart
import 'package:dio/dio.dart';
```

Then append this group inside `main()`:

```dart

group('AppUpdateService.parseRelease', () {
  test('ignores draft and prerelease releases', () {
    final service = AppUpdateService(dio: Dio());

    expect(service.parseRelease({'draft': true, 'prerelease': false}), isNull);
    expect(service.parseRelease({'draft': false, 'prerelease': true}), isNull);
  });

  test('uses first apk asset as download URL', () {
    final service = AppUpdateService(dio: Dio());
    final release = service.parseRelease({
      'tag_name': 'v1.8.1+9',
      'name': 'Folium 1.8.1',
      'body': 'Bug fixes',
      'draft': false,
      'prerelease': false,
      'html_url': 'https://github.com/orcololo/field_book/releases/tag/v1.8.1',
      'assets': [
        {'name': 'notes.txt', 'browser_download_url': 'https://github.com/orcololo/field_book/releases/download/v1.8.1/notes.txt'},
        {'name': 'folium-v1.8.1.apk', 'browser_download_url': 'https://github.com/orcololo/field_book/releases/download/v1.8.1/folium.apk'},
      ],
    });

    expect(release, isNotNull);
    expect(release!.version, const AppVersion(1, 8, 1, build: 9));
    expect(release.downloadUrl.toString(), endsWith('/folium.apk'));
  });

  test('falls back to release page when no apk asset exists', () {
    final service = AppUpdateService(dio: Dio());
    final release = service.parseRelease({
      'tag_name': 'v1.8.1',
      'draft': false,
      'prerelease': false,
      'html_url': 'https://github.com/orcololo/field_book/releases/tag/v1.8.1',
      'assets': <Object>[],
    });

    expect(release!.downloadUrl.toString(), release.releaseUrl.toString());
  });

  test('rejects non-github download URLs', () {
    final service = AppUpdateService(dio: Dio());
    final release = service.parseRelease({
      'tag_name': 'v1.8.1',
      'draft': false,
      'prerelease': false,
      'html_url': 'https://example.com/release',
      'assets': [
        {'name': 'folium.apk', 'browser_download_url': 'https://evil.example/folium.apk'},
      ],
    });

    expect(release, isNull);
  });
});
```

- [ ] **Step 2: Run tests and verify RED**

Run:

```bash
flutter test test/unit/services/app_update_service_test.dart
```

Expected: FAIL because `parseRelease` is missing.

- [ ] **Step 3: Implement release parsing**

Add these methods to `AppUpdateService`:

```dart
  AppReleaseInfo? parseRelease(Map<String, dynamic> json) {
    final isDraft = json['draft'] == true;
    final isPrerelease = json['prerelease'] == true;
    if (isDraft || isPrerelease) return null;

    final tagName = json['tag_name'] as String?;
    final version = tagName == null ? null : AppVersion.parse(tagName);
    final releaseUrl = _safeGithubUri(json['html_url'] as String?);
    if (tagName == null || version == null || releaseUrl == null) return null;

    final downloadUrl = _findApkUrl(json['assets']) ?? releaseUrl;

    return AppReleaseInfo(
      version: version,
      versionLabel: tagName,
      releaseUrl: releaseUrl,
      downloadUrl: downloadUrl,
      releaseName: json['name'] as String?,
      body: json['body'] as String?,
    );
  }

  Uri? _findApkUrl(Object? assets) {
    if (assets is! List) return null;

    for (final asset in assets) {
      if (asset is! Map<String, dynamic>) continue;
      final name = (asset['name'] as String?)?.toLowerCase();
      if (name == null || !name.endsWith('.apk')) continue;
      final uri = _safeGithubUri(asset['browser_download_url'] as String?);
      if (uri != null) return uri;
    }

    return null;
  }

  Uri? _safeGithubUri(String? value) {
    if (value == null) return null;
    final uri = Uri.tryParse(value);
    if (uri == null || uri.scheme != 'https') return null;
    const allowedHosts = {'github.com', 'objects.githubusercontent.com'};
    return allowedHosts.contains(uri.host) ? uri : null;
  }
```

- [ ] **Step 4: Run tests and verify GREEN**

Run:

```bash
flutter test test/unit/services/app_update_service_test.dart
```

Expected: PASS.

---

## Task 3: Add GitHub Fetching And Installed Version Comparison

**Files:**

- Modify: `field_book/pubspec.yaml`
- Modify: `field_book/lib/core/config/app_config.dart`
- Modify: `field_book/lib/core/services/app_update_service.dart`
- Test: `field_book/test/unit/services/app_update_service_test.dart`

- [ ] **Step 1: Add dependency**

Modify `pubspec.yaml` under `# Utilities`:

```yaml
package_info_plus: ^8.3.0
```

Run:

```bash
flutter pub get
```

Expected: dependency resolution succeeds and `pubspec.lock` updates.

- [ ] **Step 2: Add AppConfig values**

Modify `lib/core/config/app_config.dart`:

```dart
  static const String githubApiBaseUrl = String.fromEnvironment(
    'GITHUB_API_BASE_URL',
    defaultValue: 'https://api.github.com',
  );

  static const String githubReleaseOwner = String.fromEnvironment(
    'GITHUB_RELEASE_OWNER',
    defaultValue: 'orcololo',
  );

  static const String githubReleaseRepo = String.fromEnvironment(
    'GITHUB_RELEASE_REPO',
    defaultValue: 'field_book',
  );

  static const int updateCheckThrottleHours = int.fromEnvironment(
    'UPDATE_CHECK_THROTTLE_HOURS',
    defaultValue: 24,
  );
```

- [ ] **Step 3: Add failing tests for checkLatestRelease**

Add this import at the top of `app_update_service_test.dart`:

```dart
import 'package:mocktail/mocktail.dart';
```

Then append this mock and group inside `main()`:

```dart

class MockDio extends Mock implements Dio {}

Response<Map<String, dynamic>> _releaseResponse(Map<String, dynamic> data) {
  return Response<Map<String, dynamic>>(
    data: data,
    statusCode: 200,
    requestOptions: RequestOptions(path: ''),
  );
}

group('AppUpdateService.checkLatestRelease', () {
  late MockDio dio;
  late AppUpdateService service;

  setUp(() {
    dio = MockDio();
    service = AppUpdateService(dio: dio);
  });

  test('returns update available when release version is newer', () async {
    when(() => dio.get<Map<String, dynamic>>(any())).thenAnswer(
      (_) async => _releaseResponse({
        'tag_name': 'v1.8.1+9',
        'draft': false,
        'prerelease': false,
        'html_url': 'https://github.com/orcololo/field_book/releases/tag/v1.8.1',
        'assets': <Object>[],
      }),
    );

    final result = await service.checkLatestRelease(
      owner: 'orcololo',
      repo: 'field_book',
      installedVersion: const AppVersion(1, 8, 0, build: 8),
    );

    expect(result.isUpdateAvailable, isTrue);
    expect(result.latestRelease!.versionLabel, 'v1.8.1+9');
    verify(() => dio.get<Map<String, dynamic>>('/repos/orcololo/field_book/releases/latest')).called(1);
  });

  test('returns no update when latest release is same version', () async {
    when(() => dio.get<Map<String, dynamic>>(any())).thenAnswer(
      (_) async => _releaseResponse({
        'tag_name': 'v1.8.0+8',
        'draft': false,
        'prerelease': false,
        'html_url': 'https://github.com/orcololo/field_book/releases/tag/v1.8.0',
        'assets': <Object>[],
      }),
    );

    final result = await service.checkLatestRelease(
      owner: 'orcololo',
      repo: 'field_book',
      installedVersion: const AppVersion(1, 8, 0, build: 8),
    );

    expect(result.isUpdateAvailable, isFalse);
    expect(result.latestRelease, isNull);
  });
});
```

- [ ] **Step 4: Run tests and verify RED**

Run:

```bash
flutter test test/unit/services/app_update_service_test.dart
```

Expected: FAIL because `checkLatestRelease` is missing.

- [ ] **Step 5: Implement network check**

Update `AppUpdateService`:

```dart
  Future<AppUpdateCheckResult> checkLatestRelease({
    required String owner,
    required String repo,
    required AppVersion installedVersion,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/repos/$owner/$repo/releases/latest',
    );
    final data = response.data;
    final latestRelease = data == null ? null : parseRelease(data);
    final updateAvailable = latestRelease != null &&
        latestRelease.version.isNewerThan(installedVersion);

    return AppUpdateCheckResult(
      installedVersion: installedVersion,
      latestRelease: updateAvailable ? latestRelease : null,
      isUpdateAvailable: updateAvailable,
    );
  }
```

- [ ] **Step 6: Run tests and verify GREEN**

Run:

```bash
flutter test test/unit/services/app_update_service_test.dart
```

Expected: PASS.

---

## Task 4: Add Riverpod App Update State

**Files:**

- Create: `field_book/lib/core/providers/app_update_provider.dart`
- Generated: `field_book/lib/core/providers/app_update_provider.g.dart`
- Test: `field_book/test/unit/services/app_update_service_test.dart` remains service coverage; provider can be covered in a later refactor if needed.

- [ ] **Step 1: Define state and providers**

Create `lib/core/providers/app_update_provider.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
      availableRelease: clearRelease ? null : availableRelease ?? this.availableRelease,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

@Riverpod(keepAlive: true)
Dio githubDio(GithubDioRef ref) {
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
AppUpdateService appUpdateService(AppUpdateServiceRef ref) {
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
      final installed = AppVersion.parse('${packageInfo.version}+${packageInfo.buildNumber}') ??
          AppVersion.parse(packageInfo.version);
      if (installed == null) return;

      final result = await ref.read(appUpdateServiceProvider).checkLatestRelease(
            owner: AppConfig.githubReleaseOwner,
            repo: AppConfig.githubReleaseRepo,
            installedVersion: installed,
          );

      await prefs.setString(_lastCheckKey, DateTime.now().toIso8601String());
      final dismissedVersion = prefs.getString(_dismissedVersionKey);
      final release = result.latestRelease;
      state = AppUpdateState(
        availableRelease: release != null && release.versionLabel != dismissedVersion ? release : null,
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
```

- [ ] **Step 2: Generate Riverpod code**

Run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: `app_update_provider.g.dart` is generated.

- [ ] **Step 3: Run analyzer**

Run:

```bash
flutter analyze
```

Expected: no analyzer errors. If Riverpod typedef names differ from this snippet, update the provider file to match generated names rather than editing `.g.dart` manually.

---

## Task 5: Add Global Update Banner

**Files:**

- Create: `field_book/lib/shared/widgets/app_update_banner.dart`
- Modify: `field_book/lib/main_mobile.dart`
- Test: `field_book/test/widget/app_update_banner_test.dart`

- [ ] **Step 1: Add failing widget test**

Create `test/widget/app_update_banner_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:field_book/core/services/app_update_service.dart';
import 'package:field_book/shared/widgets/app_update_banner.dart';

void main() {
  testWidgets('shows update message and actions when release is available', (tester) async {
    final release = AppReleaseInfo(
      version: const AppVersion(1, 8, 1, build: 9),
      versionLabel: 'v1.8.1+9',
      releaseUrl: Uri.parse('https://github.com/orcololo/field_book/releases/tag/v1.8.1'),
      downloadUrl: Uri.parse('https://github.com/orcololo/field_book/releases/download/v1.8.1/folium.apk'),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TestableAppUpdateBanner(
            release: release,
            onOpen: () {},
            onDismiss: () {},
          ),
        ),
      ),
    );

    expect(find.textContaining('v1.8.1+9'), findsOneWidget);
    expect(find.byIcon(Icons.system_update_alt), findsOneWidget);
  });
}
```

The `TestableAppUpdateBanner` is a small stateless helper in the production widget file to keep provider-free UI testable.

- [ ] **Step 2: Run test and verify RED**

Run:

```bash
flutter test test/widget/app_update_banner_test.dart
```

Expected: FAIL because `app_update_banner.dart` does not exist.

- [ ] **Step 3: Implement banner widget**

Create `lib/shared/widgets/app_update_banner.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers/connectivity_provider.dart';
import '../../core/providers/app_update_provider.dart';
import '../../core/services/app_update_service.dart';
import '../../l10n/app_localizations.dart';

class AppUpdateBanner extends ConsumerStatefulWidget {
  const AppUpdateBanner({super.key});

  @override
  ConsumerState<AppUpdateBanner> createState() => _AppUpdateBannerState();
}

class _AppUpdateBannerState extends ConsumerState<AppUpdateBanner> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (ref.read(isOnlineValueProvider)) {
        ref.read(appUpdateNotifierProvider.notifier).checkForUpdates();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(isOnlineValueProvider);
    final state = ref.watch(appUpdateNotifierProvider);
    final release = state.availableRelease;
    if (!isOnline || release == null) return const SizedBox.shrink();

    return TestableAppUpdateBanner(
      release: release,
      onOpen: () async {
        await launchUrl(release.downloadUrl, mode: LaunchMode.externalApplication);
      },
      onDismiss: () => ref.read(appUpdateNotifierProvider.notifier).dismissCurrentUpdate(),
    );
  }
}

class TestableAppUpdateBanner extends StatelessWidget {
  final AppReleaseInfo release;
  final VoidCallback onOpen;
  final VoidCallback onDismiss;

  const TestableAppUpdateBanner({
    super.key,
    required this.release,
    required this.onOpen,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = l10n == null
        ? 'Nova versao disponivel: ${release.versionLabel}'
        : l10n.appUpdateAvailable(release.versionLabel);
    final downloadLabel = l10n?.appUpdateDownloadAction ?? 'Baixar';
    final dismissLabel = l10n?.appUpdateDismissAction ?? 'Depois';

    return MaterialBanner(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      leading: Icon(
        Icons.system_update_alt,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
      actions: [
        TextButton(onPressed: onDismiss, child: Text(dismissLabel)),
        TextButton(onPressed: onOpen, child: Text(downloadLabel)),
      ],
    );
  }
}
```

- [ ] **Step 4: Add banner globally**

Modify `lib/main_mobile.dart` imports:

```dart
import 'shared/widgets/app_update_banner.dart';
```

Modify the builder column:

```dart
builder: (context, child) {
  return Column(
    children: [
      const ConnectivityBanner(),
      const AppUpdateBanner(),
      const UploadProgressIndicator(),
      Expanded(child: child ?? const SizedBox.shrink()),
    ],
  );
},
```

- [ ] **Step 5: Run widget test and analyzer**

Run:

```bash
flutter test test/widget/app_update_banner_test.dart
flutter analyze
```

Expected: widget test passes and analyzer has no errors.

---

## Task 6: Add Settings Manual Check And Dynamic About Version

**Files:**

- Modify: `field_book/lib/features/settings/screens/settings_screen.dart`
- Modify: `field_book/lib/l10n/app_en.arb`
- Modify: `field_book/lib/l10n/app_pt.arb`
- Modify: `field_book/lib/l10n/app_es.arb`

- [ ] **Step 1: Add l10n keys**

Add to `app_en.arb`:

```json
"appUpdateAvailable": "New version available: {version}",
"@appUpdateAvailable": {"placeholders": {"version": {"type": "String"}}},
"appUpdateDownloadAction": "Download",
"appUpdateDismissAction": "Later",
"checkForUpdates": "Check for updates",
"checkForUpdatesSubtitle": "Look for a new Android APK on GitHub",
"noUpdatesAvailable": "You are using the latest version.",
"updateCheckFailed": "Could not check for updates.",
"currentVersion": "Current version: {version}",
"@currentVersion": {"placeholders": {"version": {"type": "String"}}}
```

Add equivalent keys to `app_pt.arb`:

```json
"appUpdateAvailable": "Nova versao disponivel: {version}",
"@appUpdateAvailable": {"placeholders": {"version": {"type": "String"}}},
"appUpdateDownloadAction": "Baixar",
"appUpdateDismissAction": "Depois",
"checkForUpdates": "Verificar atualizacoes",
"checkForUpdatesSubtitle": "Procurar um novo APK Android no GitHub",
"noUpdatesAvailable": "Voce ja esta usando a versao mais recente.",
"updateCheckFailed": "Nao foi possivel verificar atualizacoes.",
"currentVersion": "Versao atual: {version}",
"@currentVersion": {"placeholders": {"version": {"type": "String"}}}
```

Add equivalent keys to `app_es.arb`:

```json
"appUpdateAvailable": "Nueva version disponible: {version}",
"@appUpdateAvailable": {"placeholders": {"version": {"type": "String"}}},
"appUpdateDownloadAction": "Descargar",
"appUpdateDismissAction": "Luego",
"checkForUpdates": "Buscar actualizaciones",
"checkForUpdatesSubtitle": "Buscar un nuevo APK de Android en GitHub",
"noUpdatesAvailable": "Ya estas usando la version mas reciente.",
"updateCheckFailed": "No se pudieron buscar actualizaciones.",
"currentVersion": "Version actual: {version}",
"@currentVersion": {"placeholders": {"version": {"type": "String"}}}
```

- [ ] **Step 2: Generate localizations**

Run:

```bash
flutter gen-l10n
```

Expected: generated `app_localizations*.dart` files update.

- [ ] **Step 3: Modify Settings screen imports**

Add imports:

```dart
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/providers/app_update_provider.dart';
```

- [ ] **Step 4: Replace hardcoded About version**

In the About dialog `onTap`, load package info before showing the dialog:

```dart
onTap: () async {
  final packageInfo = await PackageInfo.fromPlatform();
  if (!context.mounted) return;
  showAboutDialog(
    context: context,
    applicationName: l10n.appTitle,
    applicationVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
    applicationLegalese: '© 2026 Folium',
    children: [
      const SizedBox(height: 16),
      Text(l10n.aboutAppDescription),
    ],
  );
},
```

- [ ] **Step 5: Add manual update tile**

Add a `ListTile` in the About card before Device ID:

```dart
const Divider(height: 1),
Consumer(
  builder: (context, ref, _) {
    final updateState = ref.watch(appUpdateNotifierProvider);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(FoliumTheme.space8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
        ),
        child: Icon(
          Icons.system_update_alt,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(l10n.checkForUpdates),
      subtitle: Text(l10n.checkForUpdatesSubtitle),
      trailing: updateState.isChecking
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      onTap: updateState.isChecking
          ? null
          : () async {
              await ref.read(appUpdateNotifierProvider.notifier).checkForUpdates(force: true);
              if (!context.mounted) return;
              final freshState = ref.read(appUpdateNotifierProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    freshState.hasUpdate
                        ? l10n.appUpdateAvailable(freshState.availableRelease!.versionLabel)
                        : freshState.errorMessage == null
                            ? l10n.noUpdatesAvailable
                            : l10n.updateCheckFailed,
                  ),
                ),
              );
            },
    );
  },
),
```

- [ ] **Step 6: Run analyzer**

Run:

```bash
flutter analyze
```

Expected: no analyzer errors.

---

## Task 7: Verification And Release-Readiness

**Files:**

- All files touched by Tasks 1-6.

- [ ] **Step 1: Run focused tests**

Run:

```bash
cd /Users/orcola/Projetos/Herbario/fieldBook/field_book
flutter test test/unit/services/app_update_service_test.dart test/widget/app_update_banner_test.dart
```

Expected: all app-update tests pass.

- [ ] **Step 2: Run full Flutter checks**

Run:

```bash
flutter analyze
flutter test
```

Expected: analyzer reports no issues and the full test suite passes.

- [ ] **Step 3: Build Android APK smoke check**

Run:

```bash
flutter build apk --dart-define=GITHUB_RELEASE_OWNER=orcololo --dart-define=GITHUB_RELEASE_REPO=field_book
```

Expected: APK build succeeds. If local Android toolchain fails for unrelated environment reasons, capture the exact failure and verify with `flutter analyze` + tests before handing off.

- [ ] **Step 4: Manual behavior check**

Run app against a release tag newer than local version:

```bash
flutter run --dart-define=GITHUB_RELEASE_OWNER=orcololo --dart-define=GITHUB_RELEASE_REPO=field_book
```

Expected:

- If GitHub latest release version is newer, a banner appears.
- Tapping download opens the APK asset URL or release page externally.
- Tapping dismiss hides that same version.
- Manual Settings check shows a SnackBar for update/no-update/error.
- Offline mode does not crash and does not block the app.

- [ ] **Step 5: Review diffs**

Run:

```bash
git --no-pager diff --check
git --no-pager diff -- pubspec.yaml lib/core/config/app_config.dart lib/core/services/app_update_service.dart lib/core/providers/app_update_provider.dart lib/shared/widgets/app_update_banner.dart lib/main_mobile.dart lib/features/settings/screens/settings_screen.dart lib/l10n/app_en.arb lib/l10n/app_pt.arb lib/l10n/app_es.arb test/unit/services/app_update_service_test.dart test/widget/app_update_banner_test.dart
```

Expected: no whitespace errors; diff is scoped to app-update feature.

---

## Acceptance Criteria

- The app checks GitHub Releases for the configured repository without using backend-envelope `ApiClient`.
- Draft/prerelease/malformed releases are ignored.
- Installed version comparison handles `vX.Y.Z`, `X.Y.Z`, and optional `+build` suffixes.
- A newer APK release shows a non-blocking global banner.
- User can dismiss a specific remote version.
- User can manually check for updates from Settings > About.
- About dialog uses the real installed version instead of hardcoded `1.8.0`.
- Network errors are silent for automatic checks and visible only for manual checks.
- No Isar schema migration is required.
- `flutter analyze`, focused tests, and full `flutter test` pass.

## Risks And Mitigations

- **Private GitHub releases:** direct unauthenticated API will fail. Mitigation: later replace the GitHub fetch adapter with a backend proxy endpoint while keeping service/provider/UI contracts.
- **GitHub API rate limits:** automatic checks are throttled with `SharedPreferences` and manual checks remain user-initiated.
- **Malformed tags:** parser returns null and the release is ignored.
- **No APK asset:** user opens the release page instead of a missing asset.
- **In-app APK installation permissions:** avoided intentionally; browser/system handles download.
- **Offline-first constraints:** update checks never block local app startup or data entry.

## GitHub Issue

- Tracking issue: `orcololo/field_book#9`.
- Keep the issue open until implementation and verification are complete.
