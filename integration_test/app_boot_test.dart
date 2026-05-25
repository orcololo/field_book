// Integration test: validates that the full Folium app boots on the host
// platform (macOS / iOS / Android) without exceptions during init, that the
// Isar database opens, providers resolve, and the first user-facing screen
// (Home or Onboarding) renders. This is the smallest test that would have
// caught the macOS sandbox "Storage error" / missing entitlements regression.
//
// Run with: flutter test integration_test/app_boot_test.dart
// Or on a specific device: flutter test integration_test/ -d macos
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:field_book/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('app boot smoke', () {
    testWidgets('app starts without throwing and renders a frame', (
      WidgetTester tester,
    ) async {
      final collectedErrors = <FlutterErrorDetails>[];
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        collectedErrors.add(details);
        originalOnError?.call(details);
      };

      try {
        app.main();
        // Allow Isar, settings, theme and home/onboarding to settle.
        await tester.pumpAndSettle(const Duration(seconds: 10));

        // The root MaterialApp must be present.
        expect(find.byType(WidgetsApp), findsOneWidget);

        // Filter out non-fatal framework noise (e.g. tooltip overflow in
        // tests). Fail on uncaught exceptions during initialization.
        final fatal = collectedErrors.where((d) {
          final msg = d.exceptionAsString();
          return !msg.contains('A RenderFlex overflowed');
        }).toList();
        expect(
          fatal,
          isEmpty,
          reason: 'App threw during boot:\n'
              '${fatal.map((e) => e.exceptionAsString()).join('\n---\n')}',
        );
      } finally {
        FlutterError.onError = originalOnError;
      }
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}
