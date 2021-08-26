import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:numus/constants/date.dart';
import 'package:numus/entities/budget.dart';
import 'package:numus/entities/settings.dart';
import 'package:numus/services/BudgetService.dart';
import 'package:numus/services/OperationsService.dart';
import 'package:numus/ui/budgets/add_or_edit_budget.dart';
import 'package:numus/ui/budgets/show_budget.dart';
import 'package:provider/provider.dart';

import 'budget_piechart.dart';

class BudgetsHomeWidget extends StatefulWidget {
  @override
  _BudgetsHomeWidgetState createState() => _BudgetsHomeWidgetState();
}

class _BudgetsHomeWidgetState extends State<BudgetsHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).budgetScreenTitle),
      ),
      body: Container(
        child: BudgetListWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddOrEditBudgetWidget()));
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class BudgetListWidget extends StatefulWidget {
  @override
  _BudgetListWidgetState createState() => _BudgetListWidgetState();
}

class _BudgetListWidgetState extends State<BudgetListWidget> {
  onTap(Budget budget) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ShowBudgetWidget(budget)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    return FutureBuilder(
        future: BudgetService().getBudgets(settings),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<BudgetCardWidget> budgets = [];
            for (var budget in snapshot.data) {
              budgets.add(BudgetCardWidget(budget, () {
                onTap(budget);
              }));
            }
            if (budgets.isNotEmpty) {
              return ListView(
                padding: EdgeInsets.all(10),
                children: budgets,
              );
            }
          }
          return EmptyBudgetsWidget();
        });
  }
}

class EmptyBudgetsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppLocalizations.of(context).budgetHomEmptyMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
        fontSize: 20,
      ),),
    );
  }
}

class BudgetCardWidget extends StatelessWidget {
  final Budget budget;
  final DateFormat formatter = DateFormat(monthDayFormat);
  final Function onTap;

  BudgetCardWidget(this.budget, this.onTap);

  getConsumedText(Settings settings, double budgeted, double consumed) {
    return consumed.toString() +
        ' ' +
        settings.currency.symbol +
        ' / ' +
        budgeted.toString() +
        ' ' +
        settings.currency.symbol;
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(budget.title,
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ),
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
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(formatter.format(budget.range.start) +
                          ' - ' +
                          formatter.format(budget.range.end)),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 63,
                      height: 63,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(0),
                      child:
                          BudgetPieChartWidget(budget.amount, budget.consumed),
                    ),
                    Container(
                        child: Text(getConsumedText(
                            settings, budget.amount, budget.consumed)))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
