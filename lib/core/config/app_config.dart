/// Central app configuration driven by --dart-define values.
///
/// Usage:
///   flutter run --dart-define=API_BASE_URL=https://api.myapp.com
///   flutter build apk --dart-define=API_BASE_URL=https://api.myapp.com
class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://herbaruimsync.orcololo.com',
  );

  static const String environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';

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
}
