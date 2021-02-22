import 'package:experiment/main.dart';
import 'package:experiment/ui/home/balance.dart';
import 'package:experiment/ui/transactions/add_amount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Show home screen', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text('Your balance'), findsOneWidget);
    expect(find.text('0.00 lei'), findsOneWidget);
    expect(find.text('Transaction list'), findsOneWidget);
    expect(find.text('There are no operations yet..'), findsOneWidget);
  });

  testWidgets('Show category types', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Select category'), findsOneWidget);
    expect(find.text('EXPENSE'), findsOneWidget);
    expect(find.text('INCOME'), findsOneWidget);
    expect(find.text('SAVINGS'), findsOneWidget);
  });

  testWidgets('Add salary', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('INCOME'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salary'));
    await tester.pumpAndSettle();
    expect(find.text('Add Salary amount'), findsOneWidget);
    await tester.tap(find.widgetWithText(CalculatorKey, '1'));
    await tester.tap(find.widgetWithText(CalculatorKey, '0'));
    await tester.tap(find.widgetWithText(CalculatorKey, '0'));
    await tester.tap(find.widgetWithText(CalculatorKey, '0'));
    await tester.tap(find.byIcon(Icons.done));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, '1000.00 lei'), findsOneWidget);
    expect(find.widgetWithText(BalanceWidget, '1000.00 lei'), findsOneWidget);
  });
}
