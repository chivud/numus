import 'package:experiment/ui/entities/category.dart';
import 'package:experiment/ui/entities/category_type.dart';


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

  Future<void> insertCategoryType(){

  }

  List<Category> getIncomeCategories() {
    return [];
  }

  List<Category> getExpenseCategories() {
    return [];
  }

  List<Category> getSavingsCategories() {
    return [];
  }
}
