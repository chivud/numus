import 'package:experiment/entities/currency.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final String currencyDisplayNameKey = 'currency_display_name';
  final String currencySymbolKey = 'currency_symbol';

  Future<Currency> getSelectedCurrency() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey(currencyDisplayNameKey)) {
      final displayName = pref.getString(currencyDisplayNameKey);
      final symbol = pref.getString(currencySymbolKey);
      return Currency(displayName, symbol);
    }
    return null;
  }

  Future<void> setSelectedCurrency(Currency currency) async{
    final pref = await SharedPreferences.getInstance();
    pref.setString(currencyDisplayNameKey, currency.displayName);
    pref.setString(currencySymbolKey, currency.symbol);
  }
}
