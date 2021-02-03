import 'package:experiment/entities/category.dart';

class Operation {
  int id;
  double amount;

  /// Unix Timestamp
  int createdAt;

  Category category;

  Operation(
      {this.id, this.amount, this.createdAt, this.category});

  Map<String, dynamic> toMap() {
    return {
      'category_id': category.id,
      'amount': amount,
      'created_at': createdAt
    };
  }
}
