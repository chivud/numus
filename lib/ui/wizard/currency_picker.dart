import 'package:flutter/material.dart';
import 'package:numus/entities/currency.dart';
import 'package:numus/entities/settings.dart';
import 'package:numus/services/SharedPreferencesService.dart';
import 'package:numus/ui/wizard/start_of_month_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CurrencyPickerWidget extends StatefulWidget {
  final List<Currency> currencies;
  final bool isInWizard;

  CurrencyPickerWidget(this.currencies, {this.isInWizard = true});

  @override
  _CurrencyPickerWidgetState createState() => _CurrencyPickerWidgetState();
}

class _CurrencyPickerWidgetState extends State<CurrencyPickerWidget> {
  List<Currency> filteredList;

  void filterList({String search}) {
    if (search != null) {
      filteredList = widget.currencies
          .where((Currency currency) =>
              currency.displayName.toLowerCase().contains(search.toLowerCase()))
          .toList();
    } else {
      filteredList = widget.currencies;
    }
  }

  @override
  void initState() {
    super.initState();
    filterList();
  }

  selectCurrency(int index, Settings settings) async {
    SharedPreferencesService()
        .setSelectedCurrency(filteredList[index])
        .then((value) {
      Currency currency = Currency(
          displayName: filteredList[index].displayName,
          symbol: filteredList[index].symbol);
      settings.setCurrency(currency);
      if (widget.isInWizard) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StartOfMonthPickerWidget()));
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).currencyTitle,
          key: Key('currency_title'),
        ),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15), hintText: AppLocalizations.of(context).currencySearch),
            onChanged: (value) {
              setState(() {
                filterList(search: value);
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              key: Key('currency_list'),
              shrinkWrap: true,
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredList[index].symbol +
                      " - " +
                      filteredList[index].displayName),
                  onTap: () => selectCurrency(index, settings),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
