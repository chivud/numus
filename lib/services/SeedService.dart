import 'package:experiment/entities/category.dart';
import 'package:experiment/entities/category_type.dart';
import 'package:flutter/material.dart';

class SeedService {
  List<Category> getCategoriesSeed() {
    return [
      Category(name: 'Salary',icon: Icon(Icons.attach_money_outlined).icon.codePoint, color: Colors.green.value, type: incomeType),
      Category(name: 'Interest',icon: Icon(Icons.star_rate).icon.codePoint, color: Colors.blue.value, type: incomeType),
      Category(name: 'Donation',icon: Icon(Icons.settings_voice).icon.codePoint, color: Colors.red.value, type: incomeType),
      Category(name: 'Food',icon: Icon(Icons.settings_cell).icon.codePoint, color: Colors.purple.value, type: expenseType),
      Category(name: 'Home',icon: Icon(Icons.home).icon.codePoint, color: Colors.yellow.value, type: expenseType),
      Category(name: 'Going out',icon: Icon(Icons.call).icon.codePoint, color: Colors.grey.value, type: expenseType),
      Category(name: 'Savings account',icon: Icon(Icons.weekend).icon.codePoint, color: Colors.orange.value, type: savingType),
      Category(name: 'Mutual fund',icon: Icon(Icons.assistant_direction).icon.codePoint, color: Colors.lime.value, type: savingType),
      Category(name: 'Stocks',icon: Icon(Icons.highlight).icon.codePoint, color: Colors.pink.value, type: savingType),
      Category(name: 'Withdraw from savings',icon: Icon(Icons.sync_alt).icon.codePoint, color: Colors.green.value, type: withdrawType),
    ];
  }
}
