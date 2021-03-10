import 'package:experiment/services/DatabaseProvider.dart';
import 'package:experiment/services/SharedPreferencesService.dart';
import 'package:experiment/ui/home/home_screen.dart';
import 'package:experiment/ui/wizard/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/application.dart';
import 'constants/currencies.dart';
import 'entities/currency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider().database;
  Currency currency = await SharedPreferencesService().getSelectedCurrency();
  Widget first;
  if(currency != null){
    first = HomeScreen();
  }else{
    first = CurrencyPickerWidget(currencies);
  }
  runApp(MyApp(first));
}

class MyApp extends StatelessWidget {
  final Widget first;

  MyApp(this.first);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: first);
  }
}
