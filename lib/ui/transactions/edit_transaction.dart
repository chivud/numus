import 'package:experiment/constants/date.dart';
import 'package:experiment/entities/category_type.dart';
import 'package:experiment/entities/currency.dart';
import 'package:experiment/entities/operation.dart';
import 'package:experiment/services/OperationsService.dart';
import 'package:experiment/ui/home/home_screen.dart';
import 'package:experiment/ui/transactions/add_amount.dart';
import 'package:experiment/ui/transactions/select_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditTransactionWidget extends StatefulWidget {
  final Operation operation;

  EditTransactionWidget(this.operation);

  @override
  _EditTransactionWidgetState createState() => _EditTransactionWidgetState();
}

class _EditTransactionWidgetState extends State<EditTransactionWidget> {
  final DateFormat dateFormat = DateFormat(dateTimeFormat);

  void onPressDone() {
    Navigator.pop(context);
  }

  void editAmount() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddAmountScreen(
                  category: widget.operation.category,
                  operation: widget.operation,
                )));
    setState(() {});
  }

  void editCategory() async {
    if (widget.operation.category.type == withdrawType) {
      return;
    }
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SelectCategoryWidget(
                  operation: widget.operation,
                )));
    setState(() {});
  }

  void editDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate:
      DateTime.fromMillisecondsSinceEpoch(widget.operation.createdAt),
      firstDate: DateTime(2019),
      lastDate: DateTime(2025),
    );
    if (date != null) {
      TimeOfDay time =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
      int newCreatedAt =
          DateTime(date.year, date.month, date.day, time.hour, time.minute)
              .millisecondsSinceEpoch;
      widget.operation.createdAt = newCreatedAt;
      OperationsService().update(widget.operation);
      setState(() {});
    }
  }

  void onPressDelete() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove transaction'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure do you want to completely remove this transaction?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Remove',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                OperationsService()
                    .removeOperation(widget.operation)
                    .then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false);
                });
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Currency currency = Provider.of<Currency>(context);
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text('Edit transaction'),
        actions: [
          IconButton(icon: Icon(Icons.done), onPressed: onPressDone),
          IconButton(icon: Icon(Icons.delete), onPressed: onPressDelete),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Container(
                padding: EdgeInsets.all(7),
                child: Icon(
                  Icons.attach_money,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              title: Text(
                widget.operation.amount.toStringAsFixed(2) + ' ' + currency.symbol,
                style: TextStyle(
                    fontSize: 24,
                    color: widget.operation.category.type == incomeType
                        ? Colors.green
                        : Colors.red),
              ),
              trailing: Icon(Icons.edit),
              onTap: editAmount,
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: Color(widget.operation.category.color),
                    shape: BoxShape.circle),
                child: Icon(
                  IconData(widget.operation.category.icon,
                      fontFamily: 'MaterialIcons'),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              title: Text(
                widget.operation.category.name,
                style: TextStyle(fontSize: 24),
              ),
              trailing: widget.operation.category.type != withdrawType ? Icon(
                  Icons.edit) : null,
              onTap: editCategory,
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Container(
                padding: EdgeInsets.all(7),
                child: Icon(
                  Icons.calendar_today_sharp,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              title: Text(
                dateFormat.format(DateTime.fromMillisecondsSinceEpoch(
                    widget.operation.createdAt)),
                style: TextStyle(fontSize: 24),
              ),
              trailing: Icon(Icons.edit),
              onTap: editDate,
            ),
          ],
        ),
      ),
    ), onWillPop: () {
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false);
    });
  }
}
