import 'package:experiment/entities/settings.dart';
import 'package:experiment/services/DatabaseProvider.dart';
import 'package:experiment/services/SharedPreferencesService.dart';
import 'package:experiment/ui/home/home_screen.dart';
import 'package:experiment/ui/wizard/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/application.dart';
import 'constants/currencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider().database;
  Settings settings = await SharedPreferencesService().getSettings();
  Widget first;
  if (settings.startOfMonth != null && settings.currency != null) {
    first = HomeScreen();
  } else {
    first = CurrencyPickerWidget(currencies);
  }
  runApp(MyApp(first, settings: settings,));
}

class MyApp extends StatelessWidget {
  final Widget first;
  final Settings settings;

  MyApp(this.first, {this.settings});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return ChangeNotifierProvider(
      create: (_) => settings,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appName,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: first),
    );
  }
}
