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
  String toString() =>
      build > 0 ? '$major.$minor.$patch+$build' : '$major.$minor.$patch';
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

  AppReleaseInfo? parseRelease(Map<String, dynamic> json) {
    final isDraft = json['draft'] == true;
    final isPrerelease = json['prerelease'] == true;
    if (isDraft || isPrerelease) return null;

    final tagName = _stringValue(json['tag_name']);
    final version = tagName == null ? null : AppVersion.parse(tagName);
    final releaseUrl = _safeGithubUri(_stringValue(json['html_url']));
    if (tagName == null || version == null || releaseUrl == null) return null;

    final downloadUrl = _findApkUrl(json['assets']) ?? releaseUrl;

    return AppReleaseInfo(
      version: version,
      versionLabel: tagName,
      releaseUrl: releaseUrl,
      downloadUrl: downloadUrl,
      releaseName: _stringValue(json['name']),
      body: _stringValue(json['body']),
    );
  }

  Uri? _findApkUrl(Object? assets) {
    if (assets is! List) return null;

    for (final asset in assets) {
      if (asset is! Map) continue;
      final name = _stringValue(asset['name'])?.toLowerCase();
      if (name == null || !name.endsWith('.apk')) continue;
      final uri = _safeGithubUri(_stringValue(asset['browser_download_url']));
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

  String? _stringValue(Object? value) => value is String ? value : null;

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
    final updateAvailable =
        latestRelease != null &&
        latestRelease.version.isNewerThan(installedVersion);

    return AppUpdateCheckResult(
      installedVersion: installedVersion,
      latestRelease: updateAvailable ? latestRelease : null,
      isUpdateAvailable: updateAvailable,
    );
  }
}
