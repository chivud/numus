import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:numus/constants/date.dart';
import 'package:numus/entities/budget.dart';
import 'package:numus/entities/category.dart';
import 'package:numus/entities/category_type.dart';
import 'package:numus/entities/settings.dart';
import 'package:numus/services/BudgetService.dart';
import 'package:numus/services/CategoryService.dart';
import 'package:provider/provider.dart';

class AddOrEditBudgetWidget extends StatefulWidget {
  final Budget budget;

  AddOrEditBudgetWidget({this.budget});

  @override
  _AddOrEditBudgetWidgetState createState() => _AddOrEditBudgetWidgetState();
}

class _AddOrEditBudgetWidgetState extends State<AddOrEditBudgetWidget> {
  final _titleFormKey = GlobalKey<FormState>();
  final titleTextFieldController = TextEditingController();

  final _amountFormKey = GlobalKey<FormState>();
  final amountTextFieldController = TextEditingController();
  DateFormat dateFormatter;
  DateTimeRange range =
  DateTimeRange(start: DateTime.now(), end: DateTime.now());
  BudgetType mode;
  Category category;

  @override
  void initState() {
    super.initState();
    if (widget.budget != null) {
      category = widget.budget.category;
      mode = widget.budget.type;
      range = widget.budget.range;
      titleTextFieldController.text = widget.budget.title;
      amountTextFieldController.text = widget.budget.amount.toString();
    }
  }

  void showDateRange() async {
    Navigator.pop(context);
    DateTimeRange result = await showDateRangePicker(
        context: context,
        firstDate: DateTime(range.start.year - 1),
        lastDate: DateTime(range.start.year + 1));
    if (result != null) {
      setState(() {
        range = result;
        mode = BudgetType.custom;
      });
    }
  }

  showTimeframeOptions() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: Icon(Icons.today),
                title:
                Text(AppLocalizations
                    .of(context)
                    .budgetAddEachMonthOption),
                onTap: () {
                  setState(() {
                    mode = BudgetType.month;
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.date_range),
                title: Text(AppLocalizations
                    .of(context)
                    .budgetAddCustomOption),
                onTap: showDateRange,
              ),
            ],
          );
        });
  }

  showCategoryOptions() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          Future categories = CategoryService().getByType(expenseType);
          return Container(
            child: FutureBuilder<List<Category>>(
              future: categories,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<Widget> children = [];
                if (snapshot.hasData) {
                  children = snapshot.data
                      .map<Widget>(
                        (Category category) =>
                        ListTile(
                          contentPadding: EdgeInsets.all(5),
                          leading: Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Color(category.color),
                                shape: BoxShape.circle),
                            child: Icon(
                              IconData(category.icon,
                                  fontFamily: 'MaterialIcons'),
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          title: Text(category.name),
                          onTap: () {
                            setState(() {
                              this.category = category;
                              Navigator.pop(context);
                            });
                          },
                        ),
                  )
                      .toList();
                } else {
                  children.add(ListTile(
                    title: Text(AppLocalizations
                        .of(context)
                        .selectCategoryThereAreNoCategories),
                    onTap: () {},
                  ));
                }
                return ListView(
                  padding: EdgeInsets.all(10),
                  children: children,
                );
              },
            ),
          );
        });
  }

  saveBudget(Settings settings) async {
    if (widget.budget == null) {
      await BudgetService().createBudget(
          titleTextFieldController.text, category,
          double.tryParse(amountTextFieldController.text), mode, settings,
          start: mode == BudgetType.custom ? range.start : null,
          end: mode == BudgetType.custom ? range.end : null);
      Navigator.pop(context);
    } else {
      await BudgetService().editBudget(
          widget.budget.id,
          titleTextFieldController.text,
          category,
          double.tryParse(amountTextFieldController.text),
          mode, settings,
          start: mode == BudgetType.custom ? range.start : null,
          end: mode == BudgetType.custom ? range.end : null);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    dateFormatter =
        DateFormat(dateFormat, AppLocalizations
            .of(context)
            .localeName);
    Settings settings = Provider.of<Settings>(context);
    return Scaffold(
      appBar: AppBar(
        title: widget.budget != null
            ? Text(AppLocalizations
            .of(context)
            .budgetEditScreenTitle)
            : Text(AppLocalizations
            .of(context)
            .budgetAddScreenTitle),
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                if (category == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label:
                        AppLocalizations
                            .of(context)
                            .budgetAddErrorConfirm,
                        onPressed: () {},
                      ),
                      duration: Duration(seconds: 10),
                      content: Text(AppLocalizations
                          .of(context)
                          .budgetAddChoseCategoryError),
                    ),
                  );
                  return;
                }
                if (mode == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label:
                        AppLocalizations
                            .of(context)
                            .budgetAddErrorConfirm,
                        onPressed: () {},
                      ),
                      duration: Duration(seconds: 10),
                      content: Text(AppLocalizations
                          .of(context)
                          .budgetAddChoseTimeframeError),
                    ),
                  );
                  return;
                }
                if (_titleFormKey.currentState.validate() &&
                    _amountFormKey.currentState.validate()) {
                  saveBudget(settings);
                }
              })
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Container(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(
                  Icons.title,
                  size: 34,
                ),
                title: Form(
                  key: _titleFormKey,
                  child: Container(
                    margin: EdgeInsets.zero,
                    child: TextFormField(
                      controller: titleTextFieldController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations
                            .of(context)
                            .budgetAddNamePlaceholder,
                      ),
                      style: TextStyle(fontSize: 24),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        _titleFormKey.currentState.validate();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppLocalizations
                              .of(context)
                              .budgetAddNameError;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Divider(),
              category == null
                  ? ListTile(
                leading: Container(
                  child: Icon(
                    Icons.help_outline,
                    size: 34,
                  ),
                ),
                title: Text(
                  AppLocalizations
                      .of(context)
                      .budgetAddChoseCategory,
                  style: TextStyle(fontSize: 24),
                ),
                onTap: showCategoryOptions,
              )
                  : ListTile(
                // contentPadding: EdgeInsets.all(0),
                leading: Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: Color(category.color),
                      shape: BoxShape.circle),
                  child: Icon(
                    IconData(category.icon, fontFamily: 'MaterialIcons'),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                title: Text(
                  category.name,
                  style: TextStyle(fontSize: 24),
                ),
                onTap: showCategoryOptions,
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.attach_money,
                  size: 34,
                ),
                title: Form(
                  key: _amountFormKey,
                  child: Container(
                    margin: EdgeInsets.zero,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: amountTextFieldController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations
                            .of(context)
                            .budgetAddAmountPlaceholder,
                      ),
                      style: TextStyle(fontSize: 24),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        _amountFormKey.currentState.validate();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppLocalizations
                              .of(context)
                              .budgetAddAmountError;
                        }
                        if (double.tryParse(value) == null) {
                          return AppLocalizations
                              .of(context)
                              .budgetAddAmountNotNumericError;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Container(
                  child: Icon(
                    Icons.calendar_today,
                    size: 34,
                  ),
                ),
                title: Text(
                  mode == null
                      ? AppLocalizations
                      .of(context)
                      .budgetAddChoseTimeframe
                      : (mode == BudgetType.custom
                      ? dateFormatter.format(range.start) +
                      ' - ' +
                      dateFormatter.format(range.end)
                      : AppLocalizations
                      .of(context)
                      .budgetAddEachMonthOption),
                  style: TextStyle(fontSize: 24),
                ),
                onTap: showTimeframeOptions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
