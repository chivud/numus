import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:numus/constants/date.dart';
import 'package:numus/entities/category_type.dart';
import 'package:numus/entities/operation.dart';
import 'package:numus/entities/settings.dart';
import 'package:numus/services/OperationsService.dart';
import 'package:numus/ui/common/daterange_button.dart';
import 'package:numus/ui/transactions/edit_transaction.dart';
import 'package:provider/provider.dart';

class TransactionListWidget extends StatefulWidget {
  @override
  _TransactionListWidgetState createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  final perPage = 50;
  DateMode mode = DateMode.month;
  DateTimeRange range;

  final PagingController<int, Operation> pagingController =
      PagingController(firstPageKey: 0);
  int startOfMonth = 1;

  DateTimeRange getTimeRange({DateTime selectedDate}) {
    DateTime now = selectedDate != null ? selectedDate : DateTime.now();
    DateTime startDate = now.day > startOfMonth
        ? DateTime(now.year, now.month, startOfMonth, 0)
        : DateTime(now.year, now.month - 1, startOfMonth, 0);
    DateTime endDate =
        DateTime(startDate.year, startDate.month + 1, startDate.day, 23, 59);
    return DateTimeRange(start: startDate, end: endDate);
  }

  initState() {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
    super.initState();
  }

  dispose() {
    pagingController.dispose();
    super.dispose();
  }

  fetchPage(int page) {
    OperationsService()
        .getOperations(mode == DateMode.all ? null : range, page, perPage)
        .then((items) {
      if (items.length < perPage) {
        pagingController.appendLastPage(items);
      } else {
        pagingController.appendPage(items, ++page);
      }
    });
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

  void selectMonth(DateTime date) {
    setState(() {
      mode = DateMode.month;
      range = getTimeRange(selectedDate: date);
      pagingController.refresh();
    });
  }

  void showAll() {
    setState(() {
      mode = DateMode.all;
      pagingController.refresh();
    });
  }

  void showDateRange(DateTimeRange dateRange) {
    setState(() {
      mode = DateMode.range;
      range = dateRange;
      pagingController.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    startOfMonth = settings.startOfMonth;
    if(range == null){
      range = getTimeRange(selectedDate: null);
    }
    final DateFormat formatter = DateFormat(dateTimeFormat);
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
                child: DateRangeButtonWidget(
                    context, mode, range, showAll, selectMonth, showDateRange),
              ),
            ],
          ),
          Expanded(
            child: PagedListView(
              padding: EdgeInsets.only(left: 10, right: 10),
              shrinkWrap: true,
              pagingController: pagingController,
              builderDelegate:
                  PagedChildBuilderDelegate(noItemsFoundIndicatorBuilder: (_) {
                return ListTile(
                  title: Text('There are no operations yet..'),
                  onTap: () {},
                );
              }, itemBuilder: (context, operation, index) {
                return ListTile(
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
                    operation.amount.toStringAsFixed(2) +
                        ' ' +
                        settings.currency.symbol,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: getAmountColor(operation)),
                  ),
                  onTap: () {
                    editTransaction(operation);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
