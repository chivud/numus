class CategoryType {
  String tag;
  String name;

  CategoryType({this.tag, this.name});

  Map<String, dynamic> toMap() {
    return {'tag': tag, 'name': name};
  }
}

CategoryType incomeType = CategoryType(tag: 'income', name: 'Income');
CategoryType expenseType = CategoryType(tag: 'expense', name: 'Expense');
CategoryType savingType = CategoryType(tag: 'savings', name: 'Savings');
