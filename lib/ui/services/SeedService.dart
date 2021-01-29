import 'package:experiment/ui/entities/category.dart';
import 'package:experiment/ui/entities/category_type.dart';

class SeedService {
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
