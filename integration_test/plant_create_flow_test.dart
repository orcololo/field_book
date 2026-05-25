// Integration test: end-to-end plant registration happy-path.
//
// Boots the real app, navigates Home → New Plant FAB → form, fills the
// minimum required fields, saves as draft (bypasses validator side-effects
// such as auto-generated identifiers and registry uniqueness), then verifies
// that the saved scientific name appears in the plant list.
//
// Uses stable widget Keys added to home_screen.dart and plant_form_screen.dart
// rather than localized text so the test is robust to copy changes.
//
// Run: flutter test integration_test/plant_create_flow_test.dart -d macos
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:field_book/main.dart' as app;

/// Pump until `condition` is true or `timeout` elapses. Avoids
/// `pumpAndSettle` deadlocks caused by persistent animations such as the
/// connectivity / upload progress banners.
Future<void> _pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration step = const Duration(milliseconds: 100),
  Duration timeout = const Duration(seconds: 20),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    if (condition()) return;
    await tester.pump(step);
  }
  if (!condition()) {
    throw TimeoutException(
      'Condition not met within $timeout',
    );
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => 'TimeoutException: $message';
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('plant create flow', () {
    testWidgets(
      'happy-path: create a plant draft and see it in the list',
      (WidgetTester tester) async {
        // Unique name per run so re-runs without DB reset still assert
        // correctly (and the find.text below stays specific to this test).
        final uniqueScientificName =
            'IntegrationTest plantae${DateTime.now().millisecondsSinceEpoch}';

        app.main();

        // Wait until the home FAB is in the tree. This implicitly waits for
        // Isar init, settings provider, onboarding decision and home build.
        await _pumpUntil(
          tester,
          () => find.byKey(const Key('home_new_plant_fab')).evaluate().isNotEmpty,
          timeout: const Duration(seconds: 30),
        );

        // 1. Open the new-plant bottom sheet.
        await tester.tap(find.byKey(const Key('home_new_plant_fab')));
        await _pumpUntil(
          tester,
          () => find
              .byKey(const Key('new_plant_full_option'))
              .evaluate()
              .isNotEmpty,
        );

        // 2. Pick the full PlantFormScreen option.
        await tester.tap(find.byKey(const Key('new_plant_full_option')));
        await _pumpUntil(
          tester,
          () => find
              .byKey(const Key('plant_form_scientific_name_field'))
              .evaluate()
              .isNotEmpty,
        );

        // 3. Fill the only required field for a draft save.
        await tester.enterText(
          find.byKey(const Key('plant_form_scientific_name_field')),
          uniqueScientificName,
        );
        await tester.pump();

        // 4. Save as draft (skips strict validator + auto-identifier path).
        final saveDraftBtn = find.byKey(
          const Key('plant_form_save_draft_button'),
        );
        // Ensure the bottom bar button is on screen before tapping.
        await tester.ensureVisible(saveDraftBtn);
        await tester.pump();
        await tester.tap(saveDraftBtn);

        // 5. Wait to return to Home (FAB visible again) AND for the plant
        // list refresh to render the new record.
        await _pumpUntil(
          tester,
          () =>
              find.byKey(const Key('home_new_plant_fab')).evaluate().isNotEmpty,
          timeout: const Duration(seconds: 15),
        );
        await _pumpUntil(
          tester,
          () => find.text(uniqueScientificName).evaluate().isNotEmpty,
          timeout: const Duration(seconds: 15),
        );

        expect(
          find.text(uniqueScientificName),
          findsOneWidget,
          reason:
              'Plant draft "$uniqueScientificName" should appear in the home plant list after save.',
        );
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );
  });
}
