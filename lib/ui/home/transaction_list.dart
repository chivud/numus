import 'package:experiment/constants/date.dart';
import 'package:experiment/entities/category_type.dart';
import 'package:experiment/entities/operation.dart';
import 'package:experiment/services/OperationsService.dart';
import 'package:experiment/ui/transactions/edit_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

enum DateMode { month, range, all }

class TransactionListWidget extends StatefulWidget {
  @override
  _TransactionListWidgetState createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  int startOfMonth = 25;
  DateMode mode = DateMode.month;
  DateTimeRange range;
  final DateFormat dateFormatter = DateFormat(dateFormat);

  DateTimeRange getTimeRange({selectedDate}) {
    DateTime now = selectedDate != null ? selectedDate : DateTime.now();
    DateTime startDate = now.day > startOfMonth
        ? DateTime(now.year, now.month, startOfMonth, 0)
        : DateTime(now.year, now.month - 1, startOfMonth, 0);
    DateTime endDate =
        DateTime(startDate.year, startDate.month + 1, startDate.day - 1, 24);
    return DateTimeRange(start: startDate, end: endDate);
  }

  initState() {
    super.initState();
    range = getTimeRange(selectedDate: null);
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

  void showDateMenu() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: Icon(Icons.all_inclusive),
                title: Text('Show all'),
                onTap: showAll,
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Select month'),
                onTap: selectMonth,
              ),
              ListTile(
                leading: Icon(Icons.date_range),
                title: Text('Select date range'),
                onTap: showDateRange,
              ),
            ],
          );
        });
  }

  void selectMonth() async {
    Navigator.pop(context);
    DateTime date = await showMonthPicker(
      initialDate: range.end,
      context: context,
      firstDate: DateTime(range.end.year - 2),
      lastDate: DateTime(range.end.year + 2),
    );
    if (date != null) {
      setState(() {
        mode = DateMode.month;
        range = getTimeRange(selectedDate: date);
      });
    }
  }

  void showAll() {
    Navigator.pop(context);
    setState(() {
      mode = DateMode.all;
    });
  }

  String getDateText(DateTimeRange range) {
    if (mode == DateMode.all) {
      return 'All';
    }
    return dateFormatter.format(range.start) +
        ' - ' +
        dateFormatter.format(range.end);
  }

  void showDateRange() async {
    Navigator.pop(context);
    DateTimeRange result = await showDateRangePicker(
        context: context,
        firstDate: DateTime(range.start.year - 1),
        lastDate: DateTime(range.start.year + 1));
    if (result != null) {
      setState(() {
        mode = DateMode.range;
        range = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Operation>> future =
        OperationsService().getOperations(mode == DateMode.all ? null : range);
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
                    getDateText(range),
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  onPressed: showDateMenu,
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
