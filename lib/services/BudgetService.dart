import 'package:numus/entities/budget.dart';
import 'package:numus/entities/category.dart';
import 'package:numus/entities/category_type.dart';
import 'package:numus/entities/settings.dart';
import 'package:numus/services/OperationsService.dart';
import 'package:sqflite/sqflite.dart';

import 'DatabaseProvider.dart';

class BudgetService {
  Future<void> createBudget(String title, Category category, double amount,
      BudgetType type, Settings settings,
      {DateTime start, DateTime end}) async {
    Budget budget = Budget(
        title: title,
        category: category,
        amount: amount,
        type: type,
        start: start != null ? start.millisecondsSinceEpoch : null,
        end: end != null ? end.millisecondsSinceEpoch : null,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        settings: settings);
    Database db = await DatabaseProvider().database;
    return await db.insert('budgets', budget.toMap());
  }

  Future<List<Budget>> getBudgets(Settings settings) async {
    Database db = await DatabaseProvider().database;
    final List<Map> result = await db.rawQuery("SELECT budgets.id, "
        "budgets.title,"
        "budgets.category_id,"
        "budgets.amount,"
        "budgets.type,"
        "budgets.start,"
        "budgets.end,"
        "budgets.created_at,"
        "categories.name as category_name,"
        "categories.icon as category_icon,"
        "categories.color as category_color,"
        "categories.type as category_type,"
        "categories.is_default as category_default "
        "FROM budgets "
        "JOIN categories ON categories.id = category_id");
    List<Budget> budgets = [];
    OperationsService opService = OperationsService();
    for (var element in result) {
      Budget budget = Budget(
          id: element['id'],
          title: element['title'],
          category: Category(
              id: element['category_id'],
              name: element['category_name'],
              icon: element['category_icon'],
              color: element['category_color'],
              type: element['category_type'] == 'income'
                  ? incomeType
                  : expenseType,
              isDefault: element['category_default']),
          amount: element['amount'],
          type: element['type'] == 'custom'
              ? BudgetType.custom
              : BudgetType.month,
          start: element['start'],
          end: element['end'],
          createdAt: element['created_at'],
          settings: settings);
      budget.consumed =
          await opService.getTotalByCategory(budget.category, budget.range);
      budgets.add(budget);
    }
    return budgets;
  }

  Future<void> delete(int id) async {
    Database db = await DatabaseProvider().database;
    await db.delete('budgets', where: "id = ?", whereArgs: [id]);
  }

  Future<void> editBudget(int id, String title, Category category, double amount,
      BudgetType type, Settings settings,
      {DateTime start, DateTime end}) async {
    Budget budget = Budget(
        title: title,
        category: category,
        amount: amount,
        type: type,
        start: start != null ? start.millisecondsSinceEpoch : null,
        end: end != null ? end.millisecondsSinceEpoch : null,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        settings: settings);
    Database db = await DatabaseProvider().database;
    return await db.update('budgets', budget.toMap(), where: "id = ?", whereArgs: [id]);
  }
}
