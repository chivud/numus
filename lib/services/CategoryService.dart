import 'package:numus/entities/category.dart';
import 'package:numus/entities/category_type.dart';
import 'package:sqflite/sqflite.dart';

import 'DatabaseProvider.dart';

class CategoryService {
  Future<List<Category>> getByType(CategoryType type) async {
    Database db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> result = await db
        .query('categories', where: 'type = ?', whereArgs: [type.tag]);
    List<Category> categories = [];
    for (var item in result) {
      categories.add(Category(id: item['id'], name: item['name'], color: item['color'], icon: item['icon'], type: type));
    }
    return categories;
  }

  Future<void> createCategory(CategoryType type, String name, int icon, int color) async{
    Category category = Category(name: name, icon: icon, color: color, type: type);
    Database db = await DatabaseProvider().database;
    return await db.insert('categories', category.toMap());
  }

  Future<Category> getWithdrawCategory() async{
    Database db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> result = await db
        .query('categories', where: 'type = ?', whereArgs: [withdrawType.tag], limit: 1);
    return Category(id: result.first['id'], name: result.first['name'], color: result.first['color'], icon: result.first['icon'], type: withdrawType);
  }
}
