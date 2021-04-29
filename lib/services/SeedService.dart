import 'package:numus/entities/category.dart';
import 'package:numus/entities/category_type.dart';
import 'package:flutter/material.dart';

class SeedService {
  List<Category> getCategoriesSeed() {
    return [
      Category(name: 'Salary',icon: Icon(Icons.payments).icon.codePoint, color: Colors.green.value, type: incomeType),
      Category(name: 'Interest',icon: Icon(Icons.request_page).icon.codePoint, color: Colors.blue.value, type: incomeType),
      Category(name: 'Bonus',icon: Icon(Icons.emoji_events).icon.codePoint, color: Colors.red.value, type: incomeType),

      Category(name: 'Transportation',icon: Icon(Icons.commute).icon.codePoint, color: Colors.brown.value, type: expenseType),
      Category(name: 'Household',icon: Icon(Icons.home).icon.codePoint, color: Colors.yellow.value, type: expenseType),
      Category(name: 'Groceries',icon: Icon(Icons.shopping_cart).icon.codePoint, color: Colors.lightGreen.value, type: expenseType),
      Category(name: 'Health',icon: Icon(Icons.healing).icon.codePoint, color: Colors.deepPurple.value, type: expenseType),
      Category(name: 'Education',icon: Icon(Icons.school).icon.codePoint, color: Colors.lightBlue.value, type: expenseType),
      Category(name: 'Going out',icon: Icon(Icons.nightlife).icon.codePoint, color: Colors.orange.value, type: expenseType),
      Category(name: 'Sport',icon: Icon(Icons.sports_basketball).icon.codePoint, color: Colors.lightBlue.value, type: expenseType),
      Category(name: 'Bills',icon: Icon(Icons.lightbulb).icon.codePoint, color: Colors.cyan.value, type: expenseType),
      Category(name: 'Pets',icon: Icon(Icons.pets).icon.codePoint, color: Colors.redAccent.value, type: expenseType),
      Category(name: 'Traveling',icon: Icon(Icons.map).icon.codePoint, color: Colors.greenAccent.value, type: expenseType),
      Category(name: 'Vacations',icon: Icon(Icons.home).icon.codePoint, color: Colors.teal.value, type: expenseType),

      Category(name: 'Savings account',icon: Icon(Icons.account_balance_wallet).icon.codePoint, color: Colors.lightGreen.value, type: savingType),
      Category(name: 'Stocks',icon: Icon(Icons.trending_up).icon.codePoint, color: Colors.cyan.value, type: savingType),

      Category(name: 'Withdraw from savings',icon: Icon(Icons.sync_alt).icon.codePoint, color: Colors.green.value, type: withdrawType),
    ];
  }
}
