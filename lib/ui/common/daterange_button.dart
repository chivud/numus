import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:numus/constants/date.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum DateMode { month, range, all }

class DateRangeButtonWidget extends StatelessWidget {
  DateFormat dateFormatter;
  final BuildContext context;
  final DateMode mode;
  final DateTimeRange range;
  final afterShowAll;
  final afterSelectMonth;
  final afterShowDateRange;
  final Color textColor;


  DateRangeButtonWidget(this.context, this.mode, this.range, this.afterShowAll, this.afterSelectMonth, this.afterShowDateRange, {this.textColor = Colors.grey}){
    dateFormatter = DateFormat(dateFormat, AppLocalizations.of(context).localeName);
  }

  String getDateText(DateTimeRange range) {
    if (mode == DateMode.all) {
      return AppLocalizations.of(context).datePickerAll;
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
                title: Text(AppLocalizations.of(context).datePickerShowAll),
                onTap: showAll,
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(AppLocalizations.of(context).datePickerSelectMonth),
                onTap: selectMonth,
              ),
              ListTile(
                leading: Icon(Icons.date_range),
                title: Text(AppLocalizations.of(context).datePickerSelectRange),
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
