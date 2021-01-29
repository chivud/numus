import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'SeedService.dart';

class DatabaseProvider {
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  initDb() async {
    // Open the database and store the reference.
    return await openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'app.db'), onCreate: (db, version) {
      db.execute(
        "CREATE TABLE category_types(id INTEGER PRIMARY KEY, tag TEXT, name TEXT)",
      );

      db.execute(
        "CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT, type_id INTEGER, FOREIGN KEY(type_id) REFERENCES category_types(id))",
      );
    }, version: 1);
  }
}
