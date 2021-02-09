class CategoryType {
  String tag;
  String name;

  CategoryType({this.tag, this.name});

  Map<String, dynamic> toMap() {
    return {'tag': tag, 'name': name};
  }
}

final CategoryType incomeType = CategoryType(tag: 'income', name: 'Income');
final CategoryType expenseType = CategoryType(tag: 'expense', name: 'Expense');
final CategoryType savingType = CategoryType(tag: 'savings', name: 'Savings');

CategoryType getCategoryTypeByTag(String tag) {
  switch (tag) {
    case 'income':
      return incomeType;
    case 'expense':
      return expenseType;
    case 'savings':
      return savingType;
  }

  throw Exception('Wrong category type tag:' + tag);
}
