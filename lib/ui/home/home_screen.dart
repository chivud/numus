import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numus/constants/application.dart';
import 'package:numus/ui/charts/charts.dart';
import 'package:numus/ui/home/balance.dart';
import 'package:numus/ui/home/transaction_list.dart';
import 'package:numus/ui/settings/settings.dart';
import 'package:numus/ui/transactions/select_category.dart';

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
              Expanded(
                child: TransactionListWidget(),
              )
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
            TextButton(
              style: TextButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                  primary: Colors.black),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChartsWidget()));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.pie_chart), Text('Charts')],
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                  primary: Colors.black),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsWidget()));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.settings),
                  Text('Settings'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
