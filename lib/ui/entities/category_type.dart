class CategoryType {
  int id;
  String tag;
  String name;

  CategoryType({this.id, this.tag, this.name});

  Map<String, dynamic> toMap() {
    return {'tag': tag, 'name': name};
  }
}
