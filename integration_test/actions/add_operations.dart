import 'package:experiment/ui/home/balance.dart';
import 'package:experiment/ui/transactions/add_amount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

showHomeScreen(WidgetTester tester, String balance,  {transactionList}) async {
  expect(find.text('Your balance'), findsOneWidget);
  expect(find.widgetWithText(BalanceWidget, balance + ' lei'), findsOneWidget);
  expect(find.text('Transaction list'), findsOneWidget);
  if(transactionList == null){
    expect(find.widgetWithText(ListTile, 'There are no operations yet..'), findsOneWidget);
  }else{
    for(String transaction in transactionList){
      expect(find.widgetWithText(ListTile, transaction), findsOneWidget);
    }
  }
}

showCategoryTypesScreen(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  await tester.pump(Duration(seconds: 3));
  expect(find.text('Select category'), findsOneWidget);
  expect(find.text('EXPENSE'), findsOneWidget);
  expect(find.text('INCOME'), findsOneWidget);
  expect(find.text('SAVINGS'), findsOneWidget);
}

addIncome(WidgetTester tester, String categoryName, String amount) async {
  await addAmount(tester, 'INCOME', categoryName, amount);
}

addExpense(WidgetTester tester, String categoryName, String amount) async {
  await addAmount(tester, 'EXPENSE', categoryName, amount);
}

addSavings(WidgetTester tester, String categoryName, String amount) async {
  await addAmount(tester, 'SAVINGS', categoryName, amount);
}

addAmount(WidgetTester tester, String categoryType, String categoryName, String amount) async{
  await tester.tap(find.text(categoryType));
  await tester.pump();
  await tester.pump(Duration(seconds: 3));
  await tester.tap(find.text(categoryName));
  await tester.pump();
  await tester.pump(Duration(seconds: 3));
  expect(find.text('Add ' + categoryName + ' amount'), findsOneWidget);
  for(var char in amount.characters){
    await tester.tap(find.widgetWithText(CalculatorKey, char));
  }
  await tester.tap(find.byIcon(Icons.done));
  await tester.pump();
  await tester.pump(Duration(seconds: 3));
}
