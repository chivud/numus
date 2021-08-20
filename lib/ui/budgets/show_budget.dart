import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:numus/constants/date.dart';
import 'package:numus/entities/budget.dart';
import 'package:numus/entities/operation.dart';
import 'package:numus/entities/settings.dart';
import 'package:numus/services/ChartService.dart';
import 'package:numus/services/OperationsService.dart';
import 'package:numus/ui/charts/charts.dart';
import 'package:numus/ui/charts/operation_linechart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowBudgetWidget extends StatefulWidget {
  final Budget budget;

  ShowBudgetWidget(this.budget);

  @override
  _ShowBudgetWidgetState createState() => _ShowBudgetWidgetState();
}

class _ShowBudgetWidgetState extends State<ShowBudgetWidget> {
  final DateFormat formatter = DateFormat(monthDayFormat);

  final PagingController<int, Operation> pagingController =
      PagingController(firstPageKey: 0);

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.budget.title),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Card(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Color(widget.budget.category.color),
                                shape: BoxShape.circle),
                            child: Icon(
                              IconData(widget.budget.category.icon,
                                  fontFamily: 'MaterialIcons'),
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              widget.budget.category.name,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                                formatter.format(widget.budget.range.start) +
                                    ' - ' +
                                    formatter.format(widget.budget.range.end)),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.budget.isUnderBudget()
                                ? AppLocalizations.of(context)
                                    .budgetShowUnderBudget
                                : AppLocalizations.of(context)
                                    .budgetShowOverBudget,
                            style: TextStyle(
                                fontSize: 20,
                                color: widget.budget.isUnderBudget()
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Card(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context).budgetShowConsumed,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          widget.budget.consumed.toString() +
                              ' ' +
                              settings.currency.symbol,
                          style: TextStyle(fontSize: 24),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context).budgetShowBudgeted,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          widget.budget.amount.toString() +
                              ' ' +
                              settings.currency.symbol,
                          style: TextStyle(fontSize: 24),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder(
              future: ChartService().getOperationsByCategory(
                  widget.budget.category,
                  widget.budget.range,
                  widget.budget.amount),
              builder: (builder, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 250,
                    child: ChartCard(
                        OperationLineChart(snapshot.data, 'burnout'),
                        AppLocalizations.of(context).budgetShowTimelineTitle),
                  );
                }
                return Text('loading...');
              }),
          Card(
            child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        AppLocalizations.of(context).homeTransactionList,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    Divider(),
                    FutureBuilder(
                        future: OperationsService().getByCategory(
                            widget.budget.range, widget.budget.category),
                        builder: (builder, snapshot) {
                          if (snapshot.hasData) {
                            List<ListTile> tiles = [];
                            for (var item in snapshot.data) {
                              tiles.add(ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: Text(formatter.format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        item.createdAt))),
                                trailing: Text(
                                  item.amount.toStringAsFixed(2) +
                                      ' ' +
                                      settings.currency.symbol,
                                ),
                              ));
                            }
                            if (tiles.isEmpty) {
                              tiles.add(ListTile(
                                title: Text(AppLocalizations.of(context)
                                    .homeTransactionListEmpty),
                              ));
                            }
                            return ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: tiles,
                            );
                          }
                          return Text('loading...');
                        }),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
