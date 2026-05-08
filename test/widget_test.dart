import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MaterialApp smoke test', (WidgetTester tester) async {
    // Smoke test: verify the test harness works.
    // Full app boot requires Isar/MapService initialization which is not
    // available in the unit test environment. Integration tests in
    // test/integration/ exercise the real app boot flow.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Folium')),
        ),
      ),
    );

    expect(find.text('Folium'), findsOneWidget);
  });
}
