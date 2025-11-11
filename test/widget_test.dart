// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:messenger_app/main.dart';

void main() {
  testWidgets('Home page renders conversation list and search', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // AppBar title
    expect(find.text('Messenger'), findsOneWidget);

    // Search field
    expect(find.byType(TextField), findsOneWidget);

    // At least one mock conversation name present
    expect(find.text('Alice Johnson'), findsOneWidget);

    // Perform a search filtering results
    await tester.enterText(find.byType(TextField), 'Design');
    await tester.pumpAndSettle();
    expect(find.text('Design Team'), findsOneWidget);
    expect(find.text('Alice Johnson'), findsNothing);
  });
}
