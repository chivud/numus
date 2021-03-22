import 'package:experiment/entities/currency.dart';
import 'package:experiment/entities/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final String currencyDisplayNameKey = 'currency_display_name';
  final String currencySymbolKey = 'currency_symbol';
  final String startOfMonthKey = 'start_of_month';

  Future<Currency> getSelectedCurrency() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey(currencyDisplayNameKey)) {
      final displayName = pref.getString(currencyDisplayNameKey);
      final symbol = pref.getString(currencySymbolKey);
      return Currency(displayName: displayName, symbol: symbol);
    }
    return null;
  }

  Future<void> setSelectedCurrency(Currency currency) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(currencyDisplayNameKey, currency.displayName);
    await pref.setString(currencySymbolKey, currency.symbol);
  }

  Future<void> setStartOfMonth(int startOfMonth) async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt(startOfMonthKey, startOfMonth);
  }

  Future<int> getStartOfMonth() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey(startOfMonthKey)) {
      return pref.getInt(startOfMonthKey);
    }
    return null;
  }

  Future<Settings> getSettings() async{
    Currency currency = await getSelectedCurrency();
    int startOfMonth = await getStartOfMonth();
    return Settings(currency, startOfMonth);
  }
}
