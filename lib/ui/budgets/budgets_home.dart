import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:numus/ui/budgets/add_budget.dart';

class BudgetsHomeWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).budgetScreenTitle),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Text('Content'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddBudgetWidget()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
