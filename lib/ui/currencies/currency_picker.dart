import 'package:experiment/entities/currency.dart';
import 'package:flutter/material.dart';

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

  selectCurrency(int index) {}

  @override
  Widget build(BuildContext context) {
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
                  onTap: () => selectCurrency(index),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
