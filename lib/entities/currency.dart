import 'package:flutter/material.dart';

class Currency extends ChangeNotifier{
  String displayName;
  String symbol;

  Currency({this.displayName, this.symbol});

  bool isInitialized(){
    return displayName != null && symbol != null;
  }

  void init({name, sym}) {
    displayName = name;
    symbol = sym;
    notifyListeners();
  }

  Currency.fromJson(Map<String, dynamic> json)
      : displayName = json['displayName'],
        symbol = json['symbol'];
}
