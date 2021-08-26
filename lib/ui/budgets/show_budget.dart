import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:numus/constants/date.dart';
import 'package:numus/entities/budget.dart';
import 'package:numus/entities/settings.dart';
import 'package:numus/services/BudgetService.dart';
import 'package:numus/services/ChartService.dart';
import 'package:numus/services/OperationsService.dart';
import 'package:numus/ui/budgets/add_or_edit_budget.dart';
import 'package:numus/ui/charts/charts.dart';
import 'package:numus/ui/charts/operation_linechart.dart';
import 'package:provider/provider.dart';

class ShowBudgetWidget extends StatelessWidget {
  final Budget budget;
  final DateFormat formatter = DateFormat(monthDayFormat);

  ShowBudgetWidget(this.budget);

  showDeleteConfirmation(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).budgetShowConfirmText),
            actions: [
              TextButton(
                  onPressed: () async  {
                    await BudgetService().delete(budget.id);
                    //get to the budget home screen
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                  AppLocalizations.of(context).budgetShowConfirmDelete,
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context).budgetShowConfirmCancel,
                    style: TextStyle(color: Colors.grey),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(budget.title),
        actions: [
          IconButton(onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddOrEditBudgetWidget(budget: budget,)));
          }, icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () => showDeleteConfirmation(context),
              icon: Icon(Icons.delete)),
        ],
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
                                color: Color(budget.category.color),
                                shape: BoxShape.circle),
                            child: Icon(
                              IconData(budget.category.icon,
                                  fontFamily: 'MaterialIcons'),
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              budget.category.name,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(formatter.format(budget.range.start) +
                                ' - ' +
                                formatter.format(budget.range.end)),
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
                            budget.isUnderBudget()
                                ? AppLocalizations.of(context)
                                    .budgetShowUnderBudget
                                : AppLocalizations.of(context)
                                    .budgetShowOverBudget,
                            style: TextStyle(
                                fontSize: 20,
                                color: budget.isUnderBudget()
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
                          budget.consumed.toString() +
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
                          budget.amount.toString() +
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
                  budget.category, budget.range, budget.amount),
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
                        future: OperationsService()
                            .getByCategory(budget.range, budget.category),
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
