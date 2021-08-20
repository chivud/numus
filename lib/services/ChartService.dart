import 'package:flutter/material.dart';
import 'package:numus/entities/category.dart';
import 'package:numus/entities/category_type.dart';
import 'package:numus/entities/charts/operations_summary.dart';
import 'package:numus/entities/charts/type_summary.dart';
import 'package:numus/services/DatabaseProvider.dart';
import 'package:numus/services/OperationsService.dart';
import 'package:sqflite/sqflite.dart';

class ChartService {
  Future<List<OperationSummary>> getSummaryByCategoryType(
      DateTimeRange range, CategoryType categoryType) async {
    if (range != null) {
      return getRangeSummary(range, categoryType);
    }
    return getAllSummary(categoryType);
  }

  Future<List<OperationSummary>> getRangeSummary(
      DateTimeRange range, CategoryType categoryType) async {
    Database db = await DatabaseProvider().database;
    List<Map> list = await db.rawQuery(
        "SELECT  categories.id, "
        "categories.name, "
        "categories.icon, "
        "categories.color, "
        "categories.type, "
        "SUM(operations.amount) as total"
        " FROM operations "
        "JOIN categories ON operations.category_id = categories.id "
        "WHERE operations.created_at BETWEEN ? AND ? "
        "AND categories.type = ?"
        "GROUP BY categories.id "
        "ORDER BY SUM(operations.amount) DESC",
        [
          range.start.millisecondsSinceEpoch,
          range.end.millisecondsSinceEpoch,
          categoryType.tag
        ]);
    return processOperationsSummaries(list);
  }

  Future<List<OperationSummary>> getAllSummary(
      CategoryType categoryType) async {
    Database db = await DatabaseProvider().database;
    List<Map> list = await db.rawQuery(
        "SELECT  categories.id, "
        "categories.name, "
        "categories.icon, "
        "categories.color, "
        "categories.type, "
        "SUM(operations.amount) as total"
        " FROM operations "
        "JOIN categories ON operations.category_id = categories.id "
        "WHERE categories.type = ? "
        "GROUP BY categories.id "
        "ORDER BY SUM(operations.amount) DESC",
        [categoryType.tag]);

    return processOperationsSummaries(list);
  }

  List<OperationSummary> processOperationsSummaries(List<Map> list) {
    List<OperationSummary> operationList = [];
    for (var item in list) {
      Category category = Category(
          id: item['id'],
          name: item['name'],
          icon: item['icon'],
          color: item['color'],
          type: getCategoryTypeByTag(item['type']));
      OperationSummary operationSummary =
          OperationSummary(category, item['total']);
      operationList.add(operationSummary);
    }
    return operationList;
  }

  Future<Map<String, List<TypeSummary>>> getTypeSummary(
      DateTimeRange range) async {
    Database db = await DatabaseProvider().database;
    List<Map> list = [];
    if (range != null) {
      list = await db.rawQuery(
          "SELECT operations.amount,"
          "operations.created_at, "
          "categories.type "
          "FROM operations "
          "JOIN categories ON categories.id = operations.category_id "
          "WHERE operations.created_at BETWEEN ? AND ? "
          "ORDER BY operations.created_at ",
          [
            range.start.millisecondsSinceEpoch,
            range.end.millisecondsSinceEpoch,
          ]);
    } else {
      list = await db.rawQuery(
        "SELECT operations.amount,"
        "operations.created_at, "
        "categories.type "
        "FROM operations "
        "JOIN categories ON categories.id = operations.category_id "
        "ORDER BY operations.created_at ",
      );
    }
    DateTime start;
    DateTime end;
    if (range != null) {
      start = range.start;
      end = range.end;
    } else if (list.isNotEmpty) {
      start = DateTime.fromMillisecondsSinceEpoch(list.first['created_at']);
      end = DateTime.fromMillisecondsSinceEpoch(list.last['created_at']);
    } else {
      return {'income': [], 'savings': []};
    }
    Map<String, double> totalBalance =
        await OperationsService().getTotalBalance(start);
    double amountIncomeToAdd = totalBalance['balance'];
    double amountSavingsToAdd = totalBalance['savings'];
    if (amountIncomeToAdd == 0.0 && list.isEmpty) {
      return {'income': [], 'savings': []};
    }
    DateTime tmpDate = DateTime(start.year, start.month, start.day);
    List<TypeSummary> incomeResult = [];
    List<TypeSummary> savingsResult = [];
    while (end.compareTo(tmpDate) > 0) {
      for (var item in list) {
        DateTime opDate =
            DateTime.fromMillisecondsSinceEpoch(item['created_at']);
        if (opDate.compareTo(tmpDate.add(Duration(days: 1))) > 0) {
          break;
        } else if (opDate.day == tmpDate.day &&
            opDate.month == tmpDate.month &&
            opDate.year == tmpDate.year) {
          if (item['type'] == expenseType.tag ||
              item['type'] == savingType.tag) {
            amountIncomeToAdd -= item['amount'];
          } else {
            amountIncomeToAdd += item['amount'];
          }
          if (item['type'] == savingType.tag) {
            amountSavingsToAdd += item['amount'];
          } else if (item['type'] == withdrawType.tag) {
            amountSavingsToAdd -= item['amount'];
          }
          list.remove(item);
        }
      }
      incomeResult.add(TypeSummary(date: tmpDate, amount: amountIncomeToAdd));
      savingsResult.add(TypeSummary(date: tmpDate, amount: amountSavingsToAdd));
      tmpDate = tmpDate.add(Duration(days: 1));
    }

    return {'income': incomeResult, 'savings': savingsResult};
  }

  Future<List<TypeSummary>> getOperationsByCategory(
      Category category, DateTimeRange range, double startingAmount) async {
    Database db = await DatabaseProvider().database;
    List<Map> list = [];
      list = await db.rawQuery(
          "SELECT operations.amount,"
          "operations.created_at, "
          "categories.type "
          "FROM operations "
          "JOIN categories ON categories.id = operations.category_id "
          "WHERE operations.created_at BETWEEN ? AND ? "
          "AND operations.category_id = ? "
          "ORDER BY operations.created_at ",
          [
            range.start.millisecondsSinceEpoch,
            range.end.millisecondsSinceEpoch,
            category.id
          ]);
    if(list.isEmpty){
      return [];
    }

    DateTime start = range.start;
    DateTime end = range.end;

    DateTime tmpDate = DateTime(start.year, start.month, start.day);
    List<TypeSummary> result = [];
    while (end.compareTo(tmpDate) > 0) {
      for (var item in list) {
        DateTime opDate =
            DateTime.fromMillisecondsSinceEpoch(item['created_at']);
        if (opDate.compareTo(tmpDate.add(Duration(days: 1))) > 0) {
          break;
        } else if (opDate.day == tmpDate.day &&
            opDate.month == tmpDate.month &&
            opDate.year == tmpDate.year) {

          startingAmount -= item['amount'];
          list.remove(item);
        }
      }
      result.add(TypeSummary(date: tmpDate, amount: startingAmount));
      tmpDate = tmpDate.add(Duration(days: 1));
    }

    return result;
  }

  Future<double> getTotalIncomeBefore(DateTime date) async {
    Database db = await DatabaseProvider().database;
    List<Map> result = await db.rawQuery(
        "SELECT TOTAL(amount) as sum FROM operations "
        "JOIN categories ON categories.id = operations.category_id "
        "WHERE categories.type = 'income'"
        "AND operations.created_at < ?",
        [
          date.millisecondsSinceEpoch,
        ]);
    return result.first['sum'];
  }
}
