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
  /// Monotonically increasing counter. Incremented on every login/logout/invalidation
  /// so that in-flight [_checkExistingSession] calls can detect they are stale
  /// and abort before overwriting a newer auth state.
  int _sessionCheckId = 0;

  @override
  AuthState build() {
    // Check for existing session on startup
    _checkExistingSession();
    return const AuthLoading();
  }

  Future<void> _checkExistingSession() async {
    // Capture the counter so we can detect if a login/logout/invalidation
    // supersedes this check while it is awaiting async work.
    final checkId = _sessionCheckId;

    final authService = ref.read(authServiceProvider);
    final hasSession = await authService.hasSession();
    if (_sessionCheckId != checkId) return; // Stale — superseded by newer auth event.

    if (!hasSession) {
      state = const AuthUnauthenticated();
      return;
    }
    try {
      final api = ref.read(apiClientProvider);
      final data = await api.get<Map<String, dynamic>>(ApiEndpoints.userProfile);
      if (_sessionCheckId != checkId) return;
      final profile = UserProfile.fromJson(data);
      // Keep the local cache fresh for future offline restarts.
      await authService.cacheProfile(profile);
      if (_sessionCheckId != checkId) return;
      state = AuthAuthenticated(profile);
    } on DioException catch (e) {
      if (_sessionCheckId != checkId) return;
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        // Server explicitly rejected our token — session is invalid.
        await authService.logout();
        if (_sessionCheckId != checkId) return;
        state = const AuthUnauthenticated();
        return;
      }
      // Any other failure (offline, timeout, 5xx) must NOT log the user out.
      // Restore the cached profile so the app works offline.
      final cached = await authService.getCachedProfile();
      if (_sessionCheckId != checkId) return;
      if (cached != null) {
        state = AuthAuthenticated(cached);
        return;
      }
      // Token present but no cache and unreachable — extremely rare edge case
      // (first launch ever while offline). Show login rather than spin forever.
      state = const AuthUnauthenticated();
    } catch (_) {
      // Unexpected non-Dio error — still try cache before giving up.
      if (_sessionCheckId != checkId) return;
      final cached = await authService.getCachedProfile();
      if (_sessionCheckId != checkId) return;
      if (cached != null) {
        state = AuthAuthenticated(cached);
        return;
      }
      // Do NOT call logout() here — tokens may still be valid.
      // An unexpected error (format exception, null dereference) should not
      // permanently destroy valid credentials.
      state = const AuthUnauthenticated();
    }
  }

  /// Called by the sync layer when it detects that tokens have been cleared
  /// externally (e.g., by AuthInterceptor after a confirmed 401 on refresh).
  /// Updates auth state without touching token storage (already cleared).
  void invalidateSession() {
    _sessionCheckId++;
    state = const AuthUnauthenticated();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _sessionCheckId++;
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
    _sessionCheckId++;
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
    _sessionCheckId++;
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
    _sessionCheckId++;
    final authService = ref.read(authServiceProvider);
    await authService.logout();
    state = const AuthUnauthenticated();
  }
}
