import 'package:experiment/services/OperationsService.dart';
import 'package:experiment/ui/transactions/add_amount.dart';
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
        child: BalanceCardWidget(),
      ),
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

class BalanceCardWidget extends StatefulWidget {
  @override
  _BalanceCardWidgetState createState() => _BalanceCardWidgetState();
}

class _BalanceCardWidgetState extends State<BalanceCardWidget> {
  double totalBalance = 0;

  @override
  void initState() {
    super.initState();
    OperationsService().getTotalBalance().then((value) => {
          setState(() {
            totalBalance = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  child: Text(
                    'Your balance',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    totalBalance.toStringAsFixed(2) + ' lei',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
