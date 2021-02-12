import 'package:experiment/services/OperationsService.dart';
import 'package:flutter/material.dart';

class BalanceWidget extends StatefulWidget {
  @override
  _BalanceWidgetState createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  double totalBalance = 0;
  double savings = 0;

  @override
  void initState() {
    super.initState();
    OperationsService().getTotalBalance().then((value) => {
          setState(() {
            totalBalance = value['balance'];
            savings = value['savings'];
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Card(
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
          ),
        ),
        if(savings > 0) Flexible(
          flex: 1,
          child: Card(
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
                          'Your savings',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        child: Text(
                          savings.toStringAsFixed(2) + ' lei',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
