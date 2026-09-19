import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hophacks2026/main.dart';

void main() {
  testWidgets('Medication Tracker smoke test and Add Medication sheet test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MedicationTrackerApp());
    await tester.pumpAndSettle();

    // Verify that the title and adherence card are present
    expect(find.text('Medication Tracker'), findsOneWidget);
    expect(find.text('Today\'s Schedule'), findsOneWidget);
    expect(find.text('All Medications'), findsOneWidget);
    expect(find.text('Add Medication'), findsOneWidget);

    // Tap the 'Add Medication' button to open the bottom sheet
    await tester.tap(find.text('Add Medication'));
    await tester.pumpAndSettle();

    // Verify that the bottom sheet sections are visible
    expect(find.text('Time of Day'), findsOneWidget);
    expect(find.text('Morning'), findsOneWidget);
    expect(find.text('Noon'), findsOneWidget);
    expect(find.text('Evening'), findsOneWidget);
    expect(find.text('Night'), findsOneWidget);
    expect(find.text('Days of the Week'), findsOneWidget);
    expect(find.text('Save Medication'), findsOneWidget);
  });
}
