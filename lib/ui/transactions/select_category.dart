import 'package:numus/entities/category.dart';
import 'package:numus/entities/category_type.dart';
import 'package:numus/entities/operation.dart';
import 'package:numus/services/CategoryService.dart';
import 'package:numus/services/OperationsService.dart';
import 'package:numus/ui/transactions/add_amount.dart';
import 'package:numus/ui/transactions/add_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SelectCategoryWidget extends StatefulWidget {
  final Operation operation;

  SelectCategoryWidget({this.operation});

  @override
  _SelectCategoryWidgetState createState() => _SelectCategoryWidgetState();
}

class _SelectCategoryWidgetState extends State<SelectCategoryWidget>
    with SingleTickerProviderStateMixin {
  bool editMode = false;

  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  changeEditMode() {
    editMode = !editMode;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select category'),
          actions: [
            IconButton(
                icon: Icon(editMode ? Icons.done : Icons.edit),
                onPressed: () => setState(changeEditMode)),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: expenseType.name.toUpperCase()),
              Tab(text: incomeType.name.toUpperCase()),
              Tab(text: savingType.name.toUpperCase()),
            ],
          ),
        ),
        body: TabBarView(children: [
          CategoriesListWidget(
            expenseType,
            editMode,
            operation: widget.operation,
          ),
          CategoriesListWidget(
            incomeType,
            editMode,
            operation: widget.operation,
          ),
          CategoriesListWidget(
            savingType,
            editMode,
            operation: widget.operation,
          ),
        ]),
      ),
    );
  }
}

class CategoriesListWidget extends StatefulWidget {
  final CategoryType type;
  final Operation operation;

  final bool editMode;

  CategoriesListWidget(this.type, this.editMode, {this.operation});

  @override
  _CategoriesListWidgetState createState() => _CategoriesListWidgetState();
}

class _CategoriesListWidgetState extends State<CategoriesListWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void refreshList() {
    setState(() {});
  }

  void onSelectCategory(Category category) {
    if (widget.operation == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddAmountScreen(category: category)));
    } else {
      widget.operation.category = category;
      OperationsService().update(widget.operation).then((value) {
        Navigator.pop(context);
      });
    }
  }

  removeCategory(Category category) async {}

  editCategory(Category category) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddCategoryWidget(widget.type, category: category)));
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Future categories = CategoryService().getByType(widget.type);
    return Container(
      child: FutureBuilder<List<Category>>(
        future: categories,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Widget> children = [];
          if (snapshot.hasData) {
            children = snapshot.data
                .map<Widget>(
                  (Category category) => ListTile(
                    contentPadding: EdgeInsets.all(5),
                    leading: Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          color: Color(category.color), shape: BoxShape.circle),
                      child: Icon(
                        IconData(category.icon, fontFamily: 'MaterialIcons'),
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    title: Text(category.name),
                    onTap: () {
                      onSelectCategory(category);
                    },
                    trailing: widget.editMode
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => removeCategory(category)),
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => editCategory(category)),
                            ],
                          )
                        : null,
                  ),
                )
                .toList();
          } else {
            children.add(ListTile(
              title: Text(
                  'There are no ${widget.type.name.toLowerCase()} categories'),
              onTap: () {},
            ));
          }
          children.add(ListTile(
            leading: Icon(Icons.add),
            title: Text('Add category...'),
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCategoryWidget(widget.type)));
              refreshList();
            },
          ));
          return ListView(
            padding: EdgeInsets.all(10),
            children: children,
          );
        },
      ),
    );
  }
}
