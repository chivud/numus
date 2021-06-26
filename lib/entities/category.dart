import 'category_type.dart';

class Category {
  int id;
  String name;
  int icon;
  int color;
  CategoryType type;
  int isDefault;

  Category({this.id, this.name, this.icon, this.color, this.type, this.isDefault = 0});

  Map<String, dynamic> toMap() {
    return {'name': name, 'icon': icon, 'color': color, 'type': type.tag, 'is_default': isDefault};
  }
}
