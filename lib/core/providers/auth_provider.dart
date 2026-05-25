import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
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

  /// One-shot subscription set when the app is in an unauthenticated state
  /// due to being offline with valid tokens. Fires [_checkExistingSession]
  /// automatically once connectivity is restored.
  StreamSubscription<ConnectivityResult>? _connectivityRetrySubscription;

  @override
  AuthState build() {
    // Cancel any pending connectivity retry if the provider is disposed
    // (e.g., container teardown in tests or app shutdown).
    ref.onDispose(() {
      _connectivityRetrySubscription?.cancel();
      _connectivityRetrySubscription = null;
    });
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
      // Short timeout: this runs on app startup and must not block the splash
      // indefinitely if the backend is reachable but slow. On timeout we fall
      // through to the cached-profile path below, preserving offline UX.
      final data = await api.get<Map<String, dynamic>>(
        ApiEndpoints.userProfile,
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
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
      // (first launch ever while offline). Show login rather than spin forever,
      // but schedule an automatic retry when connectivity is restored.
      state = const AuthUnauthenticated();
      _scheduleSessionRetryOnConnectivity();
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
      // permanently destroy valid credentials. Retry once online.
      state = const AuthUnauthenticated();
      _scheduleSessionRetryOnConnectivity();
    }
  }

  /// Sets up a one-shot connectivity listener that re-runs [_checkExistingSession]
  /// when the device comes back online. Used when the app is stuck in
  /// [AuthUnauthenticated] despite having valid stored tokens (offline startup
  /// with no cached profile). The listener cancels itself after the first
  /// non-none connectivity event, or when a user-initiated login supersedes it.
  void _scheduleSessionRetryOnConnectivity() {
    _connectivityRetrySubscription?.cancel();
    _connectivityRetrySubscription = Connectivity().onConnectivityChanged.listen(
      (result) {
        if (result != ConnectivityResult.none) {
          _connectivityRetrySubscription?.cancel();
          _connectivityRetrySubscription = null;
          // Only retry if still in unauthenticated state (user may have logged in manually).
          if (state is AuthUnauthenticated) {
            _checkExistingSession();
          }
        }
      },
    );
  }

  /// Called by the sync layer when it detects that tokens have been cleared
  /// externally (e.g., by AuthInterceptor after a confirmed 401 on refresh).
  /// Updates auth state without touching token storage (already cleared).
  void invalidateSession() {
    _sessionCheckId++;
    _connectivityRetrySubscription?.cancel();
    _connectivityRetrySubscription = null;
    state = const AuthUnauthenticated();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _sessionCheckId++;
    _connectivityRetrySubscription?.cancel();
    _connectivityRetrySubscription = null;
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
    _connectivityRetrySubscription?.cancel();
    _connectivityRetrySubscription = null;
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
    _connectivityRetrySubscription?.cancel();
    _connectivityRetrySubscription = null;
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
    _connectivityRetrySubscription?.cancel();
    _connectivityRetrySubscription = null;
    final authService = ref.read(authServiceProvider);
    await authService.logout();
    state = const AuthUnauthenticated();
  }
}
