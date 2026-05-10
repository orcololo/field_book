import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure token storage for JWT access and refresh tokens,
/// plus a cached user profile for offline startup.
class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userProfileKey = 'user_profile';

  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userProfileKey);
  }

  Future<bool> hasTokens() async {
    final token = await _storage.read(key: _accessTokenKey);
    return token != null;
  }

  /// Persist the user profile JSON so it survives offline restarts.
  Future<void> saveUserProfile(String profileJson) =>
      _storage.write(key: _userProfileKey, value: profileJson);

  /// Returns the persisted profile JSON, or null if not yet cached.
  Future<String?> getUserProfile() => _storage.read(key: _userProfileKey);
}
