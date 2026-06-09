import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment1/main.dart';

void main() {
  testWidgets('App renders login screen correctly', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title text is present
    expect(find.textContaining('Intercampus Connect'), findsOneWidget);

    // Verify that inputs exist
    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(find.text('Sign In'), findsOneWidget);
  });
}
