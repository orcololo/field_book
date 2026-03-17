/// Centralized API endpoint constants for the Folium backend.
class ApiEndpoints {
  ApiEndpoints._();

  /// Base path prefix for all API routes.
  static const String basePath = '/api/v1';

  // ── Auth ──────────────────────────────────────────────
  static const String authLogin = '$basePath/auth/login';
  static const String authRegister = '$basePath/auth/register';
  static const String authGoogle = '$basePath/auth/google';
  static const String authRefresh = '$basePath/auth/refresh';
  static const String authLogout = '$basePath/auth/logout';

  // ── Users ─────────────────────────────────────────────
  static const String users = '$basePath/users';
  static String user(String id) => '$basePath/users/$id';
  static const String userProfile = '$basePath/users/profile';

  // ── Species ───────────────────────────────────────────
  static const String species = '$basePath/species';
  static String speciesById(String id) => '$basePath/species/$id';

  // ── Registry ──────────────────────────────────────────
  static const String registries = '$basePath/registries';
  static String registry(String id) => '$basePath/registries/$id';

  // ── Collection Sessions ───────────────────────────────
  static const String sessions = '$basePath/sessions';
  static String session(String id) => '$basePath/sessions/$id';

  // ── Upload ────────────────────────────────────────────
  static const String uploadImage = '$basePath/upload/image';
  static const String uploadAudio = '$basePath/upload/audio';
  static String deleteUpload(String key) => '$basePath/upload/image/$key';

  // ── Sync ──────────────────────────────────────────────
  static const String syncPush = '$basePath/sync/push';
  static const String syncPull = '$basePath/sync/pull';

  // ── Health ────────────────────────────────────────────
  static const String health = '$basePath/health';
}
