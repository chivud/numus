import 'package:experiment/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final Future<Database> database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'app.db'),
    onCreate: (db, version){
      db.execute(
        "CREATE TABLE category_types(id INTEGER PRIMARY KEY, tag TEXT, name TEXT)",
      );

      db.execute(
        "CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT, type_id INTEGER, FOREIGN KEY(type_id) REFERENCES category_types(id))",
      );
    },
    version: 1
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Money manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen());
  }
}
