import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:field_book/core/services/app_update_service.dart';

void main() {
  group('AppVersion', () {
    test(
      'parses semantic versions with optional v prefix and build number',
      () {
        expect(
          AppVersion.parse('v1.8.1+9'),
          const AppVersion(1, 8, 1, build: 9),
        );
        expect(
          AppVersion.parse('1.8.1+9'),
          const AppVersion(1, 8, 1, build: 9),
        );
        expect(AppVersion.parse('1.8.1'), const AppVersion(1, 8, 1));
        expect(AppVersion.parse('v2.0.0'), const AppVersion(2, 0, 0));
      },
    );

    test('returns null for malformed versions', () {
      expect(AppVersion.parse('release-android'), isNull);
      expect(AppVersion.parse('1.8'), isNull);
      expect(AppVersion.parse(''), isNull);
    });

    test('compares semantic version before build number', () {
      expect(
        const AppVersion(
          1,
          8,
          1,
        ).isNewerThan(const AppVersion(1, 8, 0, build: 99)),
        isTrue,
      );
      expect(
        const AppVersion(
          1,
          8,
          0,
          build: 9,
        ).isNewerThan(const AppVersion(1, 8, 0, build: 8)),
        isTrue,
      );
      expect(
        const AppVersion(
          1,
          8,
          0,
          build: 8,
        ).isNewerThan(const AppVersion(1, 8, 0, build: 8)),
        isFalse,
      );
      expect(
        const AppVersion(
          1,
          7,
          9,
          build: 99,
        ).isNewerThan(const AppVersion(1, 8, 0, build: 1)),
        isFalse,
      );
    });
  });

  group('AppUpdateService.parseRelease', () {
    test('ignores draft and prerelease releases', () {
      final service = AppUpdateService(dio: Dio());

      expect(
        service.parseRelease({'draft': true, 'prerelease': false}),
        isNull,
      );
      expect(
        service.parseRelease({'draft': false, 'prerelease': true}),
        isNull,
      );
    });

    test('uses first apk asset as download URL', () {
      final service = AppUpdateService(dio: Dio());
      final release = service.parseRelease({
        'tag_name': 'v1.8.1+9',
        'name': 'Folium 1.8.1',
        'body': 'Bug fixes',
        'draft': false,
        'prerelease': false,
        'html_url':
            'https://github.com/orcololo/field_book/releases/tag/v1.8.1',
        'assets': [
          {
            'name': 'notes.txt',
            'browser_download_url':
                'https://github.com/orcololo/field_book/releases/download/v1.8.1/notes.txt',
          },
          {
            'name': 'folium-v1.8.1.apk',
            'browser_download_url':
                'https://github.com/orcololo/field_book/releases/download/v1.8.1/folium.apk',
          },
        ],
      });

      expect(release, isNotNull);
      expect(release!.version, const AppVersion(1, 8, 1, build: 9));
      expect(release.downloadUrl.toString(), endsWith('/folium.apk'));
    });

    test('uses first apk when multiple apk assets exist', () {
      final service = AppUpdateService(dio: Dio());
      final release = service.parseRelease({
        'tag_name': 'v1.8.1',
        'draft': false,
        'prerelease': false,
        'html_url':
            'https://github.com/orcololo/field_book/releases/tag/v1.8.1',
        'assets': [
          {
            'name': 'folium-arm64.apk',
            'browser_download_url':
                'https://github.com/orcololo/field_book/releases/download/v1.8.1/folium-arm64.apk',
          },
          {
            'name': 'folium-x64.apk',
            'browser_download_url':
                'https://github.com/orcololo/field_book/releases/download/v1.8.1/folium-x64.apk',
          },
        ],
      });

      expect(release!.downloadUrl.toString(), endsWith('/folium-arm64.apk'));
    });

    test('falls back to release page when no apk asset exists', () {
      final service = AppUpdateService(dio: Dio());
      final release = service.parseRelease({
        'tag_name': 'v1.8.1',
        'draft': false,
        'prerelease': false,
        'html_url':
            'https://github.com/orcololo/field_book/releases/tag/v1.8.1',
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
          {
            'name': 'folium.apk',
            'browser_download_url': 'https://evil.example/folium.apk',
          },
        ],
      });

      expect(release, isNull);
    });

    test('accepts objects.githubusercontent.com download URLs', () {
      final service = AppUpdateService(dio: Dio());
      final release = service.parseRelease({
        'tag_name': 'v1.8.1',
        'draft': false,
        'prerelease': false,
        'html_url':
            'https://github.com/orcololo/field_book/releases/tag/v1.8.1',
        'assets': [
          {
            'name': 'folium.apk',
            'browser_download_url':
                'https://objects.githubusercontent.com/github-production-release-asset/folium.apk',
          },
        ],
      });

      expect(release!.downloadUrl.host, 'objects.githubusercontent.com');
    });

    test('rejects insecure github URLs', () {
      final service = AppUpdateService(dio: Dio());
      final release = service.parseRelease({
        'tag_name': 'v1.8.1',
        'draft': false,
        'prerelease': false,
        'html_url': 'http://github.com/orcololo/field_book/releases/tag/v1.8.1',
        'assets': <Object>[],
      });

      expect(release, isNull);
    });

    test('ignores malformed release metadata', () {
      final service = AppUpdateService(dio: Dio());

      expect(
        service.parseRelease({
          'tag_name': 'release-android',
          'draft': false,
          'prerelease': false,
          'html_url':
              'https://github.com/orcololo/field_book/releases/tag/v1.8.1',
          'assets': <Object>[],
        }),
        isNull,
      );
      expect(
        service.parseRelease({
          'tag_name': 181,
          'draft': false,
          'prerelease': false,
          'html_url':
              'https://github.com/orcololo/field_book/releases/tag/v1.8.1',
          'assets': [
            {'name': 42, 'browser_download_url': 42},
          ],
        }),
        isNull,
      );
    });
  });

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
          'html_url':
              'https://github.com/orcololo/field_book/releases/tag/v1.8.1',
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
      verify(
        () => dio.get<Map<String, dynamic>>(
          '/repos/orcololo/field_book/releases/latest',
        ),
      ).called(1);
    });

    test('returns no update when latest release is same version', () async {
      when(() => dio.get<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => _releaseResponse({
          'tag_name': 'v1.8.0+8',
          'draft': false,
          'prerelease': false,
          'html_url':
              'https://github.com/orcololo/field_book/releases/tag/v1.8.0',
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
}

class MockDio extends Mock implements Dio {}

Response<Map<String, dynamic>> _releaseResponse(Map<String, dynamic> data) {
  return Response<Map<String, dynamic>>(
    data: data,
    statusCode: 200,
    requestOptions: RequestOptions(path: ''),
  );
}
