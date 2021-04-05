import 'package:numus/entities/currency.dart';
import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  Currency currency;
  int startOfMonth;

  Settings(this.currency, this.startOfMonth);

  void setCurrency(Currency currency) {
    this.currency = currency;
    notifyListeners();
  }

  void setStartOfMonth(int startOfMonth) {
    this.startOfMonth = startOfMonth;
    notifyListeners();
  }
}
