import 'package:experiment/entities/category.dart';
import 'package:experiment/services/CategoryService.dart';
import 'package:experiment/services/OperationsService.dart';
import 'package:experiment/ui/transactions/add_amount.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  void withdrawFromSavings() {
    CategoryService().getWithdrawCategory().then((Category category) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AddAmountScreen(category: category,)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
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
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
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
            if (savings > 0)
              Flexible(
                flex: 1,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 30, right: 20, top: 20, bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 100,
                              child: Text(
                                'Your savings',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
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
        ),
        if (savings > 0)
          Align(
            heightFactor: 2.5,
            alignment: Alignment.center,
            child: SizedBox(
              height: 35,
              width: 35,
              child: Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.green),
                child: IconButton(
                    focusColor: Colors.grey,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: EdgeInsets.all(0),
                    iconSize: 20,
                    color: Colors.white,
                    icon: Icon(Icons.west),
                    onPressed: withdrawFromSavings),
              ),
            ),
          ),
      ],
    );
  }
}
