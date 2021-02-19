import 'package:experiment/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("first test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Your balance'), findsOneWidget);
    expect(find.text('0.00 lei'), findsOneWidget);
    expect(find.text('This month'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Select category'), findsOneWidget);
    expect(find.text('Expense'), findsOneWidget);
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Savings'), findsOneWidget);
  });
}