import 'package:numus/entities/category.dart';
import 'package:numus/entities/category_type.dart';
import 'package:numus/services/SeedService.dart';
import 'package:sqflite/sqflite.dart';

import 'DatabaseProvider.dart';

class CategoryService {
  Future<List<Category>> getByType(CategoryType type) async {
    Database db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> result =
        await db.query('categories', where: 'type = ?', whereArgs: [type.tag]);
    List<Category> categories = [];
    for (var item in result) {
      categories.add(Category(
          id: item['id'],
          name: item['name'],
          color: item['color'],
          icon: item['icon'],
          type: type));
    }
    return categories;
  }

  Future<Category> getById(int id) async {
    Database db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> result =
        await db.query('categories', where: 'id = ?', whereArgs: [id]);
    String type = result.first['type'];
    return Category(
        id: result.first['id'],
        name: result.first['name'],
        color: result.first['color'],
        icon: result.first['icon'],
        type: type == 'income' ? incomeType : type == 'expense' ? expenseType : savingType);
  }

  Future<void> createCategory(
      CategoryType type, String name, int icon, int color) async {
    Category category =
        Category(name: name, icon: icon, color: color, type: type);
    Database db = await DatabaseProvider().database;
    return await db.insert('categories', category.toMap());
  }

  Future<void> editCategory(Category category) async {
    Database db = await DatabaseProvider().database;
    return await db.update('categories', category.toMap(),
        where: 'id = ?', whereArgs: [category.id]);
  }

  Future<Category> getWithdrawCategory() async {
    Database db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> result = await db.query('categories',
        where: 'type = ?', whereArgs: [withdrawType.tag], limit: 1);
    return Category(
        id: result.first['id'],
        name: result.first['name'],
        color: result.first['color'],
        icon: result.first['icon'],
        type: withdrawType);
  }

  Future<bool> categoryHasTransactions(Category category) async {
    Database db = await DatabaseProvider().database;
    List result = await db.rawQuery(
        "SELECT COUNT(*) as total FROM operations WHERE category_id = ?",
        [category.id]);

    return result.first['total'] > 0;
  }

  Future<void> removeCategory(Category category) async {
    Database db = await DatabaseProvider().database;
    return await db
        .delete('categories', where: 'id = ?', whereArgs: [category.id]);
  }

  Future<void>translateCategories(String oldLanguageCode, String newLanguageCode) async {
    List oldCategories = SeedService().categoriesTranslation[oldLanguageCode];
    List newCategories = SeedService().categoriesTranslation[newLanguageCode];
    Database db = await DatabaseProvider().database;
    Batch batch = db.batch();

    for (var i = 0; i < oldCategories.length; i++) {
      db.rawQuery(
          "UPDATE categories SET name = ? WHERE name = ? and is_default = 1",
          [newCategories[i], oldCategories[i]]);
    }

    await batch.commit();
  }
}
