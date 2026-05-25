// Integration test: end-to-end plant draft happy-path.
//
// Boots the real app, navigates Home → New Plant FAB → form, fills the
// minimum required field, saves as DRAFT (bypasses validator + auto-
// identifier path), then verifies the saved scientific name appears in
// the plant list.
//
// Uses stable widget Keys (home_screen.dart, plant_form_screen.dart)
// rather than localized text so the test is robust to copy changes.
//
// The mark-complete flow lives in plant_mark_complete_flow_test.dart so
// each end-to-end test runs in its own process (avoids re-running
// app.main() against persistent Isar state).
//
// Run: flutter test integration_test/plant_create_flow_test.dart -d macos
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:field_book/main.dart' as app;

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
    throw _TimeoutException('Condition not met within $timeout');
  }
}

class _TimeoutException implements Exception {
  final String message;
  _TimeoutException(this.message);
  @override
  String toString() => 'TimeoutException: $message';
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'happy-path: create a plant draft and see it in the list',
    (WidgetTester tester) async {
      final uniqueScientificName =
          'IntegrationTest plantae${DateTime.now().millisecondsSinceEpoch}';

      app.main();

      await _pumpUntil(
        tester,
        () =>
            find.byKey(const Key('home_new_plant_fab')).evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await tester.tap(find.byKey(const Key('home_new_plant_fab')));
      await _pumpUntil(
        tester,
        () => find
            .byKey(const Key('new_plant_full_option'))
            .evaluate()
            .isNotEmpty,
      );

      await tester.tap(find.byKey(const Key('new_plant_full_option')));
      await _pumpUntil(
        tester,
        () => find
            .byKey(const Key('plant_form_scientific_name_field'))
            .evaluate()
            .isNotEmpty,
      );

      await tester.enterText(
        find.byKey(const Key('plant_form_scientific_name_field')),
        uniqueScientificName,
      );
      await tester.pump();

      final saveDraftBtn = find.byKey(
        const Key('plant_form_save_draft_button'),
      );
      await tester.ensureVisible(saveDraftBtn);
      await tester.pump();
      await tester.tap(saveDraftBtn);

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
}
