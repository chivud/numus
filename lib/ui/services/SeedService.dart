import 'package:experiment/ui/entities/category.dart';
import 'package:experiment/ui/entities/category_type.dart';
import 'package:sqflite/sqflite.dart';

import 'DatabaseProvider.dart';

CategoryType incomeType = CategoryType(tag: 'income', name: 'Income');
CategoryType expenseType = CategoryType(tag: 'expense', name: 'Expense');
CategoryType savingType = CategoryType(tag: 'savings', name: 'Savings');

class SeedService {
  Future<void> seedDb() async {
    DatabaseProvider dbProvider = DatabaseProvider();
    final Database db = await dbProvider.database;

    List<CategoryType> categoryTypes = getCategoriesTypesSeed();
    for (var categoryType in categoryTypes){
      int id = await db.insert('category_types', categoryType.toMap());
      categoryType.id = id;
    }

    List<Category> categories = getCategoriesSeed();
    for (var category in categories){
      int id = await db.insert('categories', category.toMap());
      category.id = id;
    }
  }

  List<CategoryType> getCategoriesTypesSeed() {
    return [incomeType, expenseType, savingType];
  }

  List<Category> getCategoriesSeed() {
    return [
      Category(name: 'Salary', type: incomeType),
      Category(name: 'Interest', type: incomeType),
      Category(name: 'Donation', type: incomeType),
      Category(name: 'Food', type: expenseType),
      Category(name: 'Home', type: expenseType),
      Category(name: 'Going out', type: expenseType),
      Category(name: 'Savings account', type: savingType),
      Category(name: 'Mutual fund', type: savingType),
      Category(name: 'Stocks', type: savingType),
    ];
  }
}
