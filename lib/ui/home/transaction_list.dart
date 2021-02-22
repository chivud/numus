import 'package:experiment/constants/date.dart';
import 'package:experiment/entities/category_type.dart';
import 'package:experiment/entities/operation.dart';
import 'package:experiment/services/OperationsService.dart';
import 'package:experiment/ui/transactions/edit_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class TransactionListWidget extends StatefulWidget {
  @override
  _TransactionListWidgetState createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  int startOfMonth = 25;
  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormatter = DateFormat(dateFormat);

  DateTimeRange getTimeRange() {
    DateTime startDate = selectedDate.day > startOfMonth
        ? DateTime(selectedDate.year, selectedDate.month, startOfMonth)
        : DateTime(selectedDate.year, selectedDate.month - 1, startOfMonth);
    DateTime endDate = DateTime(startDate.year, startDate.month + 1, startDate.day - 1);
    return DateTimeRange(start: startDate, end: endDate);
  }

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
    DateTimeRange range = getTimeRange();
    Future<List<Operation>> future =
        OperationsService().getBetween(range);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, top: 15, bottom: 5),
                child: Text(
                  'Transaction list',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, top: 15, bottom: 5, right: 20),
                child: OutlineButton(
                  color: Colors.blue,
                  child: Text(
                    dateFormatter.format(range.start) + ' - ' + dateFormatter.format(range.end),
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  onPressed: () async {
                    DateTime date = await showMonthPicker(
                      initialDate: selectedDate,
                      context: context,
                      firstDate: DateTime(selectedDate.year - 2),
                      lastDate: DateTime(selectedDate.year + 2),
                    );
                    setState(() {
                      selectedDate = DateTime(date.year, date.month, selectedDate.day);
                    });
                  },
                ),
              ),
            ],
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
