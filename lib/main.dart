import 'package:experiment/services/DatabaseProvider.dart';
import 'package:experiment/services/SharedPreferencesService.dart';
import 'package:experiment/ui/home/home_screen.dart';
import 'package:experiment/ui/wizard/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/application.dart';
import 'constants/currencies.dart';
import 'entities/currency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider().database;
  Currency currency = await SharedPreferencesService().getSelectedCurrency();
  Widget first;
  if (currency.isInitialized()) {
    first = HomeScreen();
  } else {
    first = CurrencyPickerWidget(currencies);
  }
  runApp(MyApp(first, currency: currency,));
}

class MyApp extends StatelessWidget {
  final Widget first;
  final Currency currency;

  MyApp(this.first, {this.currency});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return ChangeNotifierProvider(
      create: (_) => currency,
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
