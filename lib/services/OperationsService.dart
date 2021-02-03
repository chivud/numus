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
}
