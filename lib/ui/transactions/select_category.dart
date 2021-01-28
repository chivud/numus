import 'package:experiment/ui/entities/category.dart';
import 'package:experiment/ui/entities/category_type.dart';
import 'package:experiment/ui/services/CategoryService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectCategoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select category'),
          bottom: TabBar(
            tabs: [
              Tab(text: expenseType.name.toUpperCase()),
              Tab(text: incomeType.name.toUpperCase()),
              Tab(text: savingType.name.toUpperCase()),
            ],
          ),
        ),
        body: TabBarView(children: [
          CategoriesListWidget(expenseType),
          CategoriesListWidget(incomeType),
          CategoriesListWidget(savingType),
        ]),
      ),
    );
  }
}

class CategoriesListWidget extends StatefulWidget {
  final CategoryType type;

  CategoriesListWidget(this.type);

  @override
  _CategoriesListWidgetState createState() => _CategoriesListWidgetState();
}

class _CategoriesListWidgetState extends State<CategoriesListWidget> {
  @override
  Widget build(BuildContext context) {
    List<Category> categories = CategoryService().getByType(widget.type);
    return Container(
      child: ListView(
        children: categories
            .map((Category category) =>
            ListTile(
              leading: Icon(Icons.car_rental),
              title: Text(category.name),
              onTap: () {

              },
            ))
            .toList(),
      ),
    );
  }
}
