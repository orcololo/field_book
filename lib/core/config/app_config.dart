/// Central app configuration driven by --dart-define values.
///
/// Usage:
///   flutter run --dart-define=API_BASE_URL=https://api.myapp.com
///   flutter build apk --dart-define=API_BASE_URL=https://api.myapp.com
class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  static const String environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
}
