import 'package:experiment/main.dart';
import 'package:experiment/ui/home/balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'actions/add_operations.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Show home screen', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await showHomeScreen(tester, '0.00');
  });

  testWidgets('Show category types', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await showHomeScreen(tester, '0.00');
    await showCategoryTypesScreen(tester);
  });

  testWidgets('Add salary', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await showHomeScreen(tester, '0.00');
    await showCategoryTypesScreen(tester);
    await addIncome(tester, 'Salary', '1000');
    await showHomeScreen(tester, '1000.00', transactionList: ['1000.00 lei']);
  });

  testWidgets('Add expense', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await showHomeScreen(tester, '0.00');
    await showCategoryTypesScreen(tester);
    await addExpense(tester, 'Home', '500');
    await showHomeScreen(tester, '500.00', transactionList: [
      '1000.00 lei',
      '500.00 lei'
    ]);
  });
}
