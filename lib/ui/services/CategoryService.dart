import 'package:experiment/ui/entities/category.dart';
import 'package:experiment/ui/entities/category_type.dart';

CategoryType incomeType = CategoryType(1, 'income', 'Income');
CategoryType expenseType = CategoryType(2, 'expense', 'Expense');
CategoryType savingType = CategoryType(3, 'savings', 'Savings');

class CategoryService {
  List<Category> getByType(CategoryType type) {
    switch (type.tag) {
      case 'income':
        return getIncomeCategories();
      case 'expense':
        return getExpenseCategories();
      case 'savings':
        return getSavingsCategories();
    }
  }

  List<Category> getIncomeCategories() {
    return [
      Category(1, 'Salary', incomeType),
      Category(2, 'Interest', incomeType),
      Category(3, 'Donation', incomeType),
    ];
  }

  List<Category> getExpenseCategories() {
    return [
      Category(4, 'Food', expenseType),
      Category(5, 'Home', expenseType),
      Category(6, 'Going out', expenseType),
    ];
  }

  List<Category> getSavingsCategories() {
    return [
      Category(7, 'Savings account', savingType),
      Category(8, 'Mutual fund', savingType),
      Category(9, 'Stocks', savingType),
    ];
  }
}
