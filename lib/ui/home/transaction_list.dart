import 'package:experiment/constants/date.dart';
import 'package:experiment/entities/category_type.dart';
import 'package:experiment/entities/operation.dart';
import 'package:experiment/services/OperationsService.dart';
import 'package:experiment/ui/transactions/edit_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListWidget extends StatefulWidget {
  @override
  _TransactionListWidgetState createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  Color getAmountColor(Operation operation) {
    return operation.category.type == incomeType ||
            operation.category.type == withdrawType
        ? Colors.green
        : Colors.red;
  }

  void editTransaction(Operation operation) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditTransactionWidget(operation)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Operation>> future = OperationsService().getBetween();
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 5),
            child: Text(
              'This month',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Operation>>(
              future: future,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<Widget> children = [];
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  final DateFormat formatter = DateFormat(dateTimeFormat);
                  for (Operation operation in snapshot.data) {
                    children.add(
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              color: Color(operation.category.color),
                              shape: BoxShape.circle),
                          child: Icon(
                            IconData(operation.category.icon,
                                fontFamily: 'MaterialIcons'),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(operation.category.name),
                        subtitle: Text(formatter.format(
                            DateTime.fromMillisecondsSinceEpoch(
                                operation.createdAt))),
                        trailing: Text(
                          operation.amount.toStringAsFixed(2) + ' lei',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: getAmountColor(operation)),
                        ),
                        onTap: () {
                          editTransaction(operation);
                        },
                      ),
                    );
                  }
                } else {
                  children.add(ListTile(
                    title: Text('There are no operations yet..'),
                    onTap: () {},
                  ));
                }

                return ListView(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  children: children,
                  shrinkWrap: true,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
