import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/token_storage.dart';

final _log = Logger(printer: PrettyPrinter(methodCount: 0));

/// Authenticated user profile returned by the backend.
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String role;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.role,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] as String? ?? json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      role: json['role'] as String? ?? 'collector',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'avatar': avatar,
        'role': role,
      };
}

/// Service handling authentication flows: email/password, Google OAuth,
/// token refresh, and logout.
class AuthService {
  final ApiClient _api;
  final TokenStorage _tokenStorage;
  final GoogleSignIn _googleSignIn;

  AuthService({
    required ApiClient api,
    required TokenStorage tokenStorage,
    GoogleSignIn? googleSignIn,
  })  : _api = api,
        _tokenStorage = tokenStorage,
        _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: ['email']);

  /// Register a new account with email + password.
  Future<UserProfile> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      ApiEndpoints.authRegister,
      data: {'name': name, 'email': email, 'password': password},
    );
    await _saveTokens(data);
    final profile = UserProfile.fromJson(data['user'] as Map<String, dynamic>);
    await _cacheProfile(profile);
    return profile;
  }

  /// Login with email + password.
  Future<UserProfile> login({
    required String email,
    required String password,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      ApiEndpoints.authLogin,
      data: {'email': email, 'password': password},
    );
    await _saveTokens(data);
    final profile = UserProfile.fromJson(data['user'] as Map<String, dynamic>);
    await _cacheProfile(profile);
    return profile;
  }

  /// Sign in with Google and send the ID token to the backend.
  Future<UserProfile> googleSignIn() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Google sign-in cancelled');
    }

    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) {
      throw Exception('Failed to get Google ID token');
    }

    final data = await _api.post<Map<String, dynamic>>(
      ApiEndpoints.authGoogle,
      data: {'idToken': idToken},
    );
    await _saveTokens(data);
    final profile = UserProfile.fromJson(data['user'] as Map<String, dynamic>);
    await _cacheProfile(profile);
    return profile;
  }

  /// Logout: clear tokens locally and disconnect Google.
  Future<void> logout() async {
    try {
      await _api.post(ApiEndpoints.authLogout, data: {});
    } on DioException catch (e) {
      _log.w('Logout API call failed (${e.response?.statusCode}), clearing locally');
    }
    await _tokenStorage.clearTokens();
    await _googleSignIn.signOut();
  }

  /// Check if we have stored tokens (fast, no network call).
  Future<bool> hasSession() => _tokenStorage.hasTokens();

  /// Persist an up-to-date profile to local cache (call after a successful
  /// API fetch so the cache stays fresh for offline restarts).
  Future<void> cacheProfile(UserProfile profile) => _cacheProfile(profile);

  /// Return the most recently cached profile, or null if never cached.
  Future<UserProfile?> getCachedProfile() async {
    final json = await _tokenStorage.getUserProfile();
    if (json == null) return null;
    try {
      return UserProfile.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  // ── Private ────────────────────────────────────────────

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    await _tokenStorage.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }

  Future<void> _cacheProfile(UserProfile profile) =>
      _tokenStorage.saveUserProfile(jsonEncode(profile.toJson()));
}
