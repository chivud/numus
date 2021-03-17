import 'package:experiment/entities/currency.dart';
import 'package:experiment/services/SharedPreferencesService.dart';
import 'package:experiment/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrencyPickerWidget extends StatefulWidget {
  final List<Currency> currencies;

  CurrencyPickerWidget(this.currencies);

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

  selectCurrency(int index, Currency currency) async {
    SharedPreferencesService().setSelectedCurrency(filteredList[index]).then(
        (value) {
          currency.init(name: filteredList[index].displayName, sym: filteredList[index].symbol);
          return Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false);
        });
  }

  @override
  Widget build(BuildContext context) {
    Currency currency = Provider.of<Currency>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick your currency'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15), hintText: 'search...'),
            onChanged: (value) {
              setState(() {
                filterList(search: value);
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredList[index].symbol +
                      " - " +
                      filteredList[index].displayName),
                  onTap: () => selectCurrency(index, currency),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
