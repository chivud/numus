import 'package:numus/entities/currency.dart';
import 'package:flutter/material.dart';
import 'package:numus/entities/language.dart';

class Settings extends ChangeNotifier {
  Currency currency;
  Language language;
  int startOfMonth;

  Settings(this.currency, this.startOfMonth, this.language);

  void setCurrency(Currency currency) {
    this.currency = currency;
    notifyListeners();
  }

  void setLanguage(Language language) {
    this.language = language;
    notifyListeners();
  }

  void setStartOfMonth(int startOfMonth) {
    this.startOfMonth = startOfMonth;
    notifyListeners();
  }
}
