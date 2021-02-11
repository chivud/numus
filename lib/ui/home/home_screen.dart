import 'package:experiment/ui/home/balance.dart';
import 'package:experiment/ui/home/transaction_list.dart';
import 'package:experiment/ui/transactions/select_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Money Manager')),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(flex: 1, child: BalanceWidget()),
              Flexible(flex: 3, child: TransactionListWidget()),
            ],
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectCategoryWidget()));
          },
          child: Icon(Icons.add)),
    );
  }
}
