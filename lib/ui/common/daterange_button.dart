import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:numus/constants/date.dart';

enum DateMode { month, range, all }

class DateRangeButtonWidget extends StatelessWidget {
  final DateFormat dateFormatter = DateFormat(dateFormat);
  final BuildContext context;
  final DateMode mode;
  final DateTimeRange range;
  final afterShowAll;
  final afterSelectMonth;
  final afterShowDateRange;
  final Color textColor;


  DateRangeButtonWidget(this.context, this.mode, this.range, this.afterShowAll, this.afterSelectMonth, this.afterShowDateRange, {this.textColor = Colors.grey});

  String getDateText(DateTimeRange range) {
    if (mode == DateMode.all) {
      return 'All';
    }
    return dateFormatter.format(range.start) +
        ' - ' +
        dateFormatter.format(range.end);
  }

  void showDateMenu() {
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

  void showAll() {
    Navigator.pop(context);
    afterShowAll();
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
      afterSelectMonth(date);
    }
  }
  void showDateRange() async {
    Navigator.pop(context);
    DateTimeRange result = await showDateRangePicker(
        context: context,
        firstDate: DateTime(range.start.year - 1),
        lastDate: DateTime(range.start.year + 1));
    if (result != null) {
      afterShowDateRange(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          primary: Colors.blue
      ),
      child: Text(
        getDateText(range),
        style: TextStyle(fontSize: 14, color: textColor),
      ),
      onPressed: showDateMenu,
    );
  }
}
