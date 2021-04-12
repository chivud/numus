import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:numus/entities/category_type.dart';
import 'package:numus/entities/charts/operations_summary.dart';
import 'package:numus/entities/settings.dart';
import 'package:numus/services/OperationsService.dart';
import 'package:numus/ui/charts/operation_piechart.dart';
import 'package:numus/ui/common/daterange_button.dart';
import 'package:provider/provider.dart';

class ChartsWidget extends StatefulWidget {
  @override
  _ChartsWidgetState createState() => _ChartsWidgetState();
}

class _ChartsWidgetState extends State<ChartsWidget> {
  DateMode mode = DateMode.month;
  DateTimeRange range;
  int startOfMonth = 1;

  afterShowAll() {
    setState(() {
      mode = DateMode.all;
    });
  }

  afterSelectMonth(DateTime date) {
    setState(() {
      mode = DateMode.month;
      range = getTimeRange(selectedDate: date);
    });
  }

  afterShowDateRange(DateTimeRange dateRange) {
    setState(() {
      mode = DateMode.range;
      range = dateRange;
    });
  }

  DateTimeRange getTimeRange({DateTime selectedDate}) {
    DateTime now = selectedDate != null ? selectedDate : DateTime.now();
    DateTime startDate = now.day > startOfMonth
        ? DateTime(now.year, now.month, startOfMonth, 0)
        : DateTime(now.year, now.month - 1, startOfMonth, 0);
    DateTime endDate =
        DateTime(startDate.year, startDate.month + 1, startDate.day, 23, 59);
    return DateTimeRange(start: startDate, end: endDate);
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    startOfMonth = settings.startOfMonth;
    if (range == null) {
      range = getTimeRange(selectedDate: null);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Charts'),
        actions: [
          Container(
            padding: EdgeInsets.all(10),
            child: DateRangeButtonWidget(
              context,
              mode,
              range,
              afterShowAll,
              afterSelectMonth,
              afterShowDateRange,
              textColor: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PageView(
              scrollDirection: Axis.vertical,
              children: [
                FutureBuilder(
                  future: OperationsService()
                      .getSummaryByCategoryType(mode == DateMode.all ? null : range, expenseType),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    List<OperationSummary> list = snapshot.data as List<OperationSummary>;
                    if (list != null) {
                      return ChartWidget(
                          expenseType, range, list, settings);
                    }
                    return Text('loading...');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartWidget extends StatelessWidget {
  final CategoryType categoryType;
  final DateTimeRange range;
  final List<OperationSummary> items;
  final Settings settings;

  ChartWidget(this.categoryType, this.range, this.items, this.settings);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, top: 15, bottom: 5),
                    child: Text(
                      categoryType.name,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: OperationPieChart(
                        this.items, categoryType.tag, settings),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
