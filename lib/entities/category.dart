import 'category_type.dart';

class Category {
  int id;
  String name;
  CategoryType type;

  Category({this.id, this.name, this.type});

  Map<String, dynamic> toMap() {
    return {'name': name, 'type': type.tag};
  }
}
