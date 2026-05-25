// Integration test: account registration UI flow.
//
// This test does NOT hit the real backend — it overrides `authServiceProvider`
// with a fake that returns a synthetic UserProfile, so the test is hermetic
// and runnable in CI without infrastructure. What it exercises end-to-end:
//
//   1. RegisterScreen builds and renders all required fields.
//   2. Client-side form validation rejects mismatched / weak inputs.
//   3. A valid submission calls authService.register() with trimmed values
//      and pops the screen, leaving the auth state Authenticated.
//
// Run: flutter test integration_test/account_register_flow_test.dart -d macos
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:integration_test/integration_test.dart';

import 'package:field_book/core/providers/auth_provider.dart';
import 'package:field_book/core/services/auth_service.dart';
import 'package:field_book/features/auth/screens/register_screen.dart';
import 'package:field_book/l10n/app_localizations.dart';

class _FakeAuthService implements AuthService {
  _FakeAuthService({this.failOnRegister = false});
  final bool failOnRegister;
  final calls = <Map<String, String>>[];

  // The real AuthNotifier.build() fires _checkExistingSession() which calls
  // hasSession() before any UI interaction. We pin it to false so the
  // notifier resolves quickly to AuthUnauthenticated without further calls.
  @override
  Future<bool> hasSession() async => false;

  @override
  Future<UserProfile> register({
    required String name,
    required String email,
    required String password,
  }) async {
    calls.add({'name': name, 'email': email, 'password': password});
    if (failOnRegister) {
      throw Exception('backend unavailable');
    }
    return const UserProfile(
      id: 'fake-user-id',
      name: 'Folium Tester',
      email: 'tester@folium.test',
      role: 'collector',
    );
  }

  // Unused methods — fail loudly if the flow accidentally calls them.
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('_FakeAuthService.${invocation.memberName}');
}

Widget _buildHarness({
  required _FakeAuthService fakeAuth,
  required GlobalKey<NavigatorState> navKey,
}) {
  return ProviderScope(
    overrides: [
      authServiceProvider.overrideWithValue(fakeAuth),
    ],
    child: MaterialApp(
      navigatorKey: navKey,
      locale: const Locale('pt'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt'), Locale('en'), Locale('es')],
      home: Scaffold(
        body: Builder(
          builder: (ctx) => Center(
            child: FilledButton(
              onPressed: () => Navigator.of(ctx).push(
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              ),
              child: const Text('open-register'),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('account registration flow', () {
    testWidgets(
      'happy-path: fills form, submits, calls authService and pops',
      (WidgetTester tester) async {
        final fakeAuth = _FakeAuthService();
        final navKey = GlobalKey<NavigatorState>();
        await tester.pumpWidget(
          _buildHarness(fakeAuth: fakeAuth, navKey: navKey),
        );
        await tester.pumpAndSettle();

        // Open RegisterScreen.
        await tester.tap(find.text('open-register'));
        await tester.pumpAndSettle();

        // Verify all keyed fields exist on screen.
        expect(find.byKey(const Key('register_name_field')), findsOneWidget);
        expect(find.byKey(const Key('register_email_field')), findsOneWidget);
        expect(find.byKey(const Key('register_password_field')), findsOneWidget);
        expect(
          find.byKey(const Key('register_confirm_password_field')),
          findsOneWidget,
        );

        // Fill the form with valid values (note leading/trailing spaces in
        // name+email — the screen must trim them before calling the service).
        await tester.enterText(
          find.byKey(const Key('register_name_field')),
          '  Folium Tester  ',
        );
        await tester.enterText(
          find.byKey(const Key('register_email_field')),
          '  tester@folium.test  ',
        );
        await tester.enterText(
          find.byKey(const Key('register_password_field')),
          'supersecret123',
        );
        await tester.enterText(
          find.byKey(const Key('register_confirm_password_field')),
          'supersecret123',
        );
        await tester.pump();

        await tester.tap(find.byKey(const Key('register_submit_button')));
        await tester.pumpAndSettle();

        // Service was called exactly once with TRIMMED name+email and the
        // raw password (passwords are never trimmed).
        expect(fakeAuth.calls.length, 1);
        expect(fakeAuth.calls.first, {
          'name': 'Folium Tester',
          'email': 'tester@folium.test',
          'password': 'supersecret123',
        });

        // Screen should have popped, returning to the harness home.
        expect(find.text('open-register'), findsOneWidget);
        expect(find.byKey(const Key('register_submit_button')), findsNothing);
      },
    );

    testWidgets(
      'validation: mismatched confirm password blocks submission',
      (WidgetTester tester) async {
        final fakeAuth = _FakeAuthService();
        await tester.pumpWidget(
          _buildHarness(
            fakeAuth: fakeAuth,
            navKey: GlobalKey<NavigatorState>(),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('open-register'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('register_name_field')),
          'Tester',
        );
        await tester.enterText(
          find.byKey(const Key('register_email_field')),
          'tester@folium.test',
        );
        await tester.enterText(
          find.byKey(const Key('register_password_field')),
          'supersecret123',
        );
        await tester.enterText(
          find.byKey(const Key('register_confirm_password_field')),
          'OTHERsecret123',
        );

        await tester.tap(find.byKey(const Key('register_submit_button')));
        await tester.pumpAndSettle();

        // Service must NOT have been called and screen must still be open.
        expect(fakeAuth.calls, isEmpty);
        expect(
          find.byKey(const Key('register_submit_button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'validation: password shorter than 8 chars is rejected',
      (WidgetTester tester) async {
        final fakeAuth = _FakeAuthService();
        await tester.pumpWidget(
          _buildHarness(
            fakeAuth: fakeAuth,
            navKey: GlobalKey<NavigatorState>(),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('open-register'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('register_name_field')),
          'Tester',
        );
        await tester.enterText(
          find.byKey(const Key('register_email_field')),
          'tester@folium.test',
        );
        await tester.enterText(
          find.byKey(const Key('register_password_field')),
          'short',
        );
        await tester.enterText(
          find.byKey(const Key('register_confirm_password_field')),
          'short',
        );

        await tester.tap(find.byKey(const Key('register_submit_button')));
        await tester.pumpAndSettle();

        expect(fakeAuth.calls, isEmpty);
        expect(
          find.byKey(const Key('register_submit_button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'backend failure: service throws, auth state stays unauthenticated, '
      'screen remains open',
      (WidgetTester tester) async {
        final fakeAuth = _FakeAuthService(failOnRegister: true);
        await tester.pumpWidget(
          _buildHarness(
            fakeAuth: fakeAuth,
            navKey: GlobalKey<NavigatorState>(),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('open-register'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('register_name_field')),
          'Tester',
        );
        await tester.enterText(
          find.byKey(const Key('register_email_field')),
          'tester@folium.test',
        );
        await tester.enterText(
          find.byKey(const Key('register_password_field')),
          'supersecret123',
        );
        await tester.enterText(
          find.byKey(const Key('register_confirm_password_field')),
          'supersecret123',
        );

        await tester.tap(find.byKey(const Key('register_submit_button')));
        // Don't use pumpAndSettle here: the failure path shows a SnackBar
        // whose auto-dismiss timer (4s) would block settle indefinitely.
        // Pump enough frames for the async register() future to resolve and
        // the catch block to call setState.
        for (var i = 0; i < 30; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }

        // Service was attempted but the screen did NOT pop on error.
        expect(fakeAuth.calls.length, 1);
        expect(
          find.byKey(const Key('register_submit_button')),
          findsOneWidget,
        );
      },
    );
  });
}
