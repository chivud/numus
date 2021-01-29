import 'package:experiment/ui/home/home_screen.dart';
import 'package:experiment/ui/services/DatabaseProvider.dart';
import 'package:experiment/ui/services/SeedService.dart';
import 'package:flutter/material.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider().database;
  // TODO: seed only if necessary
  SeedService().seedDb();
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
