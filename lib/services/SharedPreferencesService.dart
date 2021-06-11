import 'package:numus/entities/currency.dart';
import 'package:numus/entities/language.dart';
import 'package:numus/entities/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final String currencyDisplayNameKey = 'currency_display_name';
  final String currencySymbolKey = 'currency_symbol';
  final String startOfMonthKey = 'start_of_month';
  final String languageCode = 'language_code';
  final String languageName = 'language_name';
  final String languageFlag = 'language_flag';

  Future<Currency> getSelectedCurrency() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey(currencyDisplayNameKey)) {
      final displayName = pref.getString(currencyDisplayNameKey);
      final symbol = pref.getString(currencySymbolKey);
      return Currency(displayName: displayName, symbol: symbol);
    }
    return null;
  }

  Future<Language> getSelectedLanguage() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey(languageCode)) {
      final code = pref.getString(languageCode);
      final flag = pref.getString(languageFlag);
      final name = pref.getString(languageName);
      return Language(name, code, flag);
    }
    return null;
  }

  Future<void> setSelectedCurrency(Currency currency) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(currencyDisplayNameKey, currency.displayName);
    await pref.setString(currencySymbolKey, currency.symbol);
  }
  Future<void> setSelectedLanguage(Language language) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(languageCode, language.code);
    await pref.setString(languageName, language.name);
    await pref.setString(languageFlag, language.flag);
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
    Language language = await getSelectedLanguage();
    int startOfMonth = await getStartOfMonth();
    return Settings(currency, startOfMonth, language);
  }
}
