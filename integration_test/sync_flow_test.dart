// Integration test: sync UI flow.
//
// Strategy: this test is hermetic — it never hits a real backend. Instead it
// overrides the Riverpod auth + sync graph so that:
//
//   * `authNotifierProvider` resolves immediately to AuthAuthenticated
//     (so the SyncNotifier auth-gate in sync() does not reject the call).
//   * `syncServiceProvider` returns a fake SyncService whose `sync()` waits
//     briefly (long enough for the UI to observe isSyncing=true) and then
//     completes with a deterministic SyncResult.
//
// A minimal UI mirroring the home-screen sync trigger watches the
// `syncNotifierProvider` state and exposes:
//   - a 'sync_test_button' that calls `.sync()` on the notifier
//   - text widgets reflecting isSyncing / pushed counts / lastError
//
// We then assert that tapping the button transitions isSyncing through
// true → false and that the result counters are reflected in the UI.
//
// Run: flutter test integration_test/sync_flow_test.dart -d macos
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:field_book/core/providers/auth_provider.dart';
import 'package:field_book/core/providers/sync_provider.dart';
import 'package:field_book/core/services/auth_service.dart';
import 'package:field_book/core/sync/sync_service.dart';

class _FakeAuthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    // Skip session check / network entirely — pin to authenticated.
    return const AuthAuthenticated(
      UserProfile(
        id: 'fake-user',
        name: 'Folium Tester',
        email: 'tester@folium.test',
        role: 'collector',
      ),
    );
  }
}

/// SyncNotifier subclass that skips the connectivity / periodic auto-sync
/// wiring done by the real notifier's build(). Without this, the real
/// _setupAutoSync() fires immediately on test start, calls
/// _syncIfTokensPresent() — which reads tokenStorage (no tokens in tests)
/// and ends up invalidating the (fake) auth state, breaking the gate inside
/// `sync()`.
class _FakeSyncNotifier extends SyncNotifier {
  @override
  SyncState build() => const SyncState();
}

/// SyncService stub that records calls and completes after a short delay.
/// Constructed with throwaway api/mediaUpload args; methods are overridden
/// to avoid any real I/O.
class _FakeSyncService implements SyncService {
  _FakeSyncService({
    this.delay = const Duration(milliseconds: 200),
    this.result = const SyncResult(pushed: 3, pulled: 5),
    this.shouldThrow = false,
  });

  final Duration delay;
  final SyncResult result;
  final bool shouldThrow;
  final calls = <String?>[];

  @override
  Future<SyncResult> sync({String? deviceId}) async {
    calls.add(deviceId);
    await Future<void>.delayed(delay);
    if (shouldThrow) throw Exception('synthetic-sync-failure');
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('_FakeSyncService.${invocation.memberName}');
}

class _SyncProbe extends ConsumerWidget {
  const _SyncProbe();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(syncNotifierProvider);
    final auth = ref.watch(authNotifierProvider);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'auth=${auth.runtimeType}',
                key: const Key('sync_test_auth'),
              ),
              Text(
                'isSyncing=${state.isSyncing}',
                key: const Key('sync_test_status'),
              ),
              Text(
                'pushed=${state.lastResult?.pushed ?? 0}',
                key: const Key('sync_test_pushed'),
              ),
              Text(
                'error=${state.lastError ?? ''}',
                key: const Key('sync_test_error'),
              ),
              FilledButton(
                key: const Key('sync_test_button'),
                onPressed: state.isSyncing
                    ? null
                    : () => ref.read(syncNotifierProvider.notifier).sync(),
                child: const Text('Sync'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('sync flow', () {
    testWidgets(
      'happy-path: tap sync → isSyncing toggles → result counters update',
      (WidgetTester tester) async {
        final fakeSync = _FakeSyncService(
          delay: const Duration(milliseconds: 300),
          result: const SyncResult(pushed: 2, pulled: 7),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authNotifierProvider.overrideWith(_FakeAuthNotifier.new),
              syncNotifierProvider.overrideWith(_FakeSyncNotifier.new),
              syncServiceProvider.overrideWithValue(fakeSync),
            ],
            child: const _SyncProbe(),
          ),
        );
        await tester.pumpAndSettle();

        // Initial state.
        expect(find.text('isSyncing=false'), findsOneWidget);
        expect(find.text('pushed=0'), findsOneWidget);

        // Trigger sync.
        await tester.tap(find.byKey(const Key('sync_test_button')));
        // Pump several short frames so the onPressed Future runs its
        // synchronous prelude (state = copyWith(isSyncing: true)) and the
        // ConsumerWidget rebuilds.
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 10));
        }
        expect(find.text('isSyncing=true'), findsOneWidget);

        // Wait past the fake delay.
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pumpAndSettle();

        expect(find.text('isSyncing=false'), findsOneWidget);
        expect(find.text('pushed=2'), findsOneWidget);
        expect(find.text('error='), findsOneWidget);
        expect(fakeSync.calls.length, 1);
      },
    );

    testWidgets(
      'failure-path: service throws → isSyncing returns to false and error '
      'message surfaces in state',
      (WidgetTester tester) async {
        final fakeSync = _FakeSyncService(
          delay: const Duration(milliseconds: 100),
          shouldThrow: true,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authNotifierProvider.overrideWith(_FakeAuthNotifier.new),
              syncNotifierProvider.overrideWith(_FakeSyncNotifier.new),
              syncServiceProvider.overrideWithValue(fakeSync),
            ],
            child: const _SyncProbe(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('sync_test_button')));
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 10));
        }
        expect(find.text('isSyncing=true'), findsOneWidget);

        await tester.pump(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        expect(find.text('isSyncing=false'), findsOneWidget);
        // Error text should contain our synthetic message.
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is Text &&
                (w.data ?? '').contains('synthetic-sync-failure'),
          ),
          findsOneWidget,
        );
        expect(fakeSync.calls.length, 1);
      },
    );
  });
}
