import 'package:flutter/material.dart';
import 'package:numus/entities/category.dart';
import 'package:numus/entities/settings.dart';

enum BudgetType { custom, month }

class Budget {
  int id;
  String title;
  double amount;

  /// Unix Timestamp
  int createdAt;

  /// Unix Timestamp
  int start;

  /// Unix Timestamp
  int end;

  BudgetType type;
  Category category;

  DateTimeRange range;
  double consumed;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category_id': category.id,
      'start': start,
      'end': end,
      'type': type == BudgetType.custom ? 'custom' : 'month',
      'created_at': createdAt
    };
  }


  Budget({this.id,
    this.title,
    this.amount,
    this.createdAt,
    this.start,
    this.end,
    this.type,
    this.category,
    this.consumed,
    Settings settings}) {
    setDateRange(settings);
  }

  void setDateRange(Settings settings) {
    if (type == BudgetType.month) {
      DateTime now = DateTime.now();
      DateTime startDate = now.day > settings.startOfMonth
          ? DateTime(now.year, now.month, settings.startOfMonth, 0)
          : DateTime(now.year, now.month - 1, settings.startOfMonth, 0);
      DateTime endDate =
      DateTime(startDate.year, startDate.month + 1, startDate.day, 23, 59);
      range = DateTimeRange(start: startDate, end: endDate);
    } else {
      range = DateTimeRange(
          start: DateTime.fromMillisecondsSinceEpoch(start),
          end: DateTime.fromMillisecondsSinceEpoch(end));
    }
  }

  bool isUnderBudget(){
    return consumed < amount;
  }
}
