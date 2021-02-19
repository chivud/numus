import 'package:experiment/constants/application.dart';
import 'package:experiment/ui/home/balance.dart';
import 'package:experiment/ui/home/transaction_list.dart';
import 'package:experiment/ui/transactions/select_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appName)),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BalanceWidget(),
              Expanded(child: TransactionListWidget(),)
            ],
          )),
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectCategoryWidget()));
            },
            child: Icon(Icons.add)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton(
              padding: EdgeInsets.all(10),
              shape: CircleBorder(),
              onPressed: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.bar_chart), Text('label')],
              ),
            ),
            FlatButton(
              padding: EdgeInsets.all(10),
              shape: CircleBorder(),
              onPressed: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.bar_chart), Text('label')],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
