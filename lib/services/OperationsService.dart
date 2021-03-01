import 'package:experiment/entities/category.dart';
import 'package:experiment/entities/category_type.dart';
import 'package:experiment/entities/operation.dart';
import 'package:experiment/services/DatabaseProvider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class OperationsService {
  Future<void> persistOperation(Operation operation) async {
    Database db = await DatabaseProvider().database;

    await db.insert('operations', operation.toMap());
  }

  Future<Map<String, double>> getTotalBalance() async {
    Database db = await DatabaseProvider().database;

    List<Map> expenses =
        await db.rawQuery("SELECT TOTAL(amount) as sum FROM operations "
            "JOIN categories ON categories.id = operations.category_id "
            "WHERE categories.type = 'expense'");
    List<Map> income =
        await db.rawQuery("SELECT TOTAL(amount) as sum FROM operations "
            "JOIN categories ON categories.id = operations.category_id "
            "WHERE categories.type = 'income'");

    List<Map> savings =
        await db.rawQuery("SELECT TOTAL(amount) as sum FROM operations "
            "JOIN categories ON categories.id = operations.category_id "
            "WHERE categories.type = 'savings'");

    List<Map> withdraw =
        await db.rawQuery("SELECT TOTAL(amount) as sum FROM operations "
            "JOIN categories ON categories.id = operations.category_id "
            "WHERE categories.type = 'withdraw'");
    var incomeSum = income.first['sum'];
    var expensesSum = expenses.first['sum'];
    var savingsSum = savings.first['sum'];
    var withdrawSum = withdraw.first['sum'];
    return {
      'balance': incomeSum - expensesSum - savingsSum + withdrawSum,
      'savings': savingsSum - withdrawSum
    };
  }

  Future<List<Operation>> getOperations(DateTimeRange range, int page, int perPage) async {
    print("page " + page.toString());
    if(range != null){
      return getBetween(range, page, perPage);
    }
    return getAll(page, perPage);
  }

  Future<List<Operation>> getAll(int page, int perPage) async{
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
            "ORDER BY operations.created_at DESC "
            "LIMIT ? OFFSET ?",[perPage, page * perPage]);
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

  Future<List<Operation>> getBetween(DateTimeRange range, page, int perPage) async {
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
        "ORDER BY operations.created_at DESC "
        "LIMIT ? OFFSET ?",
        [
          range.start.millisecondsSinceEpoch,
          range.end.millisecondsSinceEpoch,
          perPage,
          page * perPage
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

  Future<int> removeOperation(Operation operation) async {
    Database db = await DatabaseProvider().database;
    return await db
        .delete('operations', where: 'id = ?', whereArgs: [operation.id]);
  }

  Future<int> update(Operation operation) async {
    Database db = await DatabaseProvider().database;
    return await db.update('operations', operation.toMap(),
        where: 'id = ?', whereArgs: [operation.id]);
  }
}
