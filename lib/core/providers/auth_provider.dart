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
      state = AuthAuthenticated(UserProfile.fromJson(data));
    } catch (_) {
      // Token exists but profile fetch failed (expired/invalid) — clear session.
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
