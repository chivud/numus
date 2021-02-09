import 'package:experiment/entities/category.dart';
import 'package:experiment/entities/category_type.dart';
import 'package:experiment/entities/operation.dart';
import 'package:experiment/services/DatabaseProvider.dart';
import 'package:sqflite/sqflite.dart';

class OperationsService {
  Future<void> persistOperation(Operation operation) async {
    Database db = await DatabaseProvider().database;

    await db.insert('operations', operation.toMap());
  }

  Future<double> getTotalBalance() async {
    Database db = await DatabaseProvider().database;

    List<Map> expenses =
        await db.rawQuery("SELECT TOTAL(amount) as sum FROM operations "
            "JOIN categories ON categories.id = operations.category_id "
            "WHERE categories.type = 'expense' OR categories.type = 'savings'");
    List<Map> income =
        await db.rawQuery("SELECT TOTAL(amount) as sum FROM operations "
            "JOIN categories ON categories.id = operations.category_id "
            "WHERE categories.type = 'income'");
    var incomeSum = income.first['sum'];
    var expense = expenses.first['sum'];
    return incomeSum - expense;
  }

  Future<List<Operation>> getBetween() async {
    //TODO Remote hardcoded
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1);
    Database db = await DatabaseProvider().database;

    List<Map> list = await db.rawQuery(
        "SELECT  operations.id, "
        "operations.amount, "
        "operations.created_at, "
        "operations.category_id, "
        "categories.name, "
        "categories.icon, "
        "categories.color, "
        "categories.type"
        " FROM operations "
        "JOIN categories ON operations.category_id = categories.id "
        "WHERE operations.created_at BETWEEN ? AND ? "
            "ORDER BY operations.created_at DESC",
        [
          firstDayOfMonth.millisecondsSinceEpoch,
          lastDayOfMonth.millisecondsSinceEpoch
        ]);
    Map categories = {};
    List<Operation> operations = [];
    for (var item in list) {
      Category category;
      if (categories.containsKey(item['category_id'])) {
        category = categories[item['category_id']];
      } else {
        category = Category(
            id: item['category_id'],
            name: item['name'],
            icon: item['icon'],
            color: item['color'],
            type: getCategoryTypeByTag(item['type']));
        categories[item['category_id']] = category;
      }
      Operation operation = Operation(
          id: item['id'],
          amount: item['amount'],
          createdAt: item['created_at'],
          category: category);
      operations.add(operation);
    }
    return operations;
  }
}
