import 'package:experiment/ui/entities/category.dart';
import 'package:experiment/ui/entities/category_type.dart';
import 'package:experiment/ui/services/DatabaseProvider.dart';
import 'package:sqflite/sqflite.dart';

class CategoryService {
  Future<List<Category>> getByType(CategoryType type) async {
    Database db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> result = await db
        .query('categories', where: 'type = ?', whereArgs: [type.tag]);
    List<Category> categories = [];
    for (var item in result) {
      categories.add(Category(id: item['id'], name: item['name'], type: type));
    }
    return categories;
  }
}
