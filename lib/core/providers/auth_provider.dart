import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../services/auth_service.dart';

part 'auth_provider.g.dart';

/// Authentication state — either unauthenticated or holding the user profile.
sealed class AuthState {
  const AuthState();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthAuthenticated extends AuthState {
  final UserProfile user;
  const AuthAuthenticated(this.user);
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  return AuthService(
    api: ref.read(apiClientProvider),
    tokenStorage: ref.read(tokenStorageProvider),
  );
}

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // Check for existing session on startup
    _checkExistingSession();
    return const AuthLoading();
  }

  Future<void> _checkExistingSession() async {
    final authService = ref.read(authServiceProvider);
    final hasSession = await authService.hasSession();
    if (!hasSession) {
      state = const AuthUnauthenticated();
      return;
    }
    try {
      final api = ref.read(apiClientProvider);
      final data = await api.get<Map<String, dynamic>>(ApiEndpoints.userProfile);
      final profile = UserProfile.fromJson(data);
      // Keep the local cache fresh for future offline restarts.
      await authService.cacheProfile(profile);
      state = AuthAuthenticated(profile);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        // Server explicitly rejected our token — session is invalid.
        await authService.logout();
        state = const AuthUnauthenticated();
        return;
      }
      // Any other failure (offline, timeout, 5xx) must NOT log the user out.
      // Restore the cached profile so the app works offline.
      final cached = await authService.getCachedProfile();
      if (cached != null) {
        state = AuthAuthenticated(cached);
        return;
      }
      // Token present but no cache and unreachable — extremely rare edge case
      // (first launch ever while offline). Show login rather than spin forever.
      state = const AuthUnauthenticated();
    } catch (_) {
      // Unexpected non-Dio error — still try cache before giving up.
      final cached = await authService.getCachedProfile();
      if (cached != null) {
        state = AuthAuthenticated(cached);
        return;
      }
      await authService.logout();
      state = const AuthUnauthenticated();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.login(email: email, password: password);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = const AuthUnauthenticated();
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.register(
        name: name,
        email: email,
        password: password,
      );
      state = AuthAuthenticated(user);
    } catch (e) {
      state = const AuthUnauthenticated();
      rethrow;
    }
  }

  Future<void> googleSignIn() async {
    state = const AuthLoading();
    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.googleSignIn();
      state = AuthAuthenticated(user);
    } catch (e) {
      state = const AuthUnauthenticated();
      rethrow;
    }
  }

  Future<void> logout() async {
    final authService = ref.read(authServiceProvider);
    await authService.logout();
    state = const AuthUnauthenticated();
  }
}
