import 'package:experiment/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddAmountScreen extends StatelessWidget {
  Category category;

  AddAmountScreen({this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add ${category.name} amount')),
      body: Container(
        padding: EdgeInsets.all(10),
        child: AmountWidget(),
      ),
    );
  }
}

class AmountWidget extends StatefulWidget {
  @override
  _AmountWidgetState createState() => _AmountWidgetState();
}

class _AmountWidgetState extends State<AmountWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        autofocus: true,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
        ],
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: true),
      ),
    );
  }
}
