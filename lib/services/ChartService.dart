import 'package:flutter/material.dart';
import 'package:numus/entities/category.dart';
import 'package:numus/entities/category_type.dart';
import 'package:numus/entities/charts/operations_summary.dart';
import 'package:numus/services/DatabaseProvider.dart';
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
        "GROUP BY categories.id",
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
}
