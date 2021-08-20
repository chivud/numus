import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class BudgetPieChartWidget extends StatelessWidget {
  final double budgetAmount;
  final double consumedAmount;

  BudgetPieChartWidget(this.budgetAmount, this.consumedAmount);

  getSeries() {
    Color consumedColor =
        budgetAmount > consumedAmount ? Colors.green : Colors.red;
    Color budgetColor = Colors.grey;
    List<BudgetData> data = [
      BudgetData(
          0,
          consumedAmount,
          charts.Color(
              r: consumedColor.red,
              g: consumedColor.green,
              b: consumedColor.blue,
              a: consumedColor.alpha)),
      BudgetData(
          1,
          budgetAmount < consumedAmount ? 0 : budgetAmount - consumedAmount,
          charts.Color(
              r: budgetColor.red,
              g: budgetColor.green,
              b: budgetColor.blue,
              a: budgetColor.alpha)),
    ];
    return [
      charts.Series<BudgetData, int>(
        id: 'Sales',
        domainFn: (BudgetData item, _) => item.index,
        measureFn: (BudgetData item, _) => item.amount,
        colorFn: (BudgetData item, _) => item.color,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DonutPieChart(getSeries());
  }
}

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutPieChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: true,
        layoutConfig: charts.LayoutConfig(
          leftMarginSpec: charts.MarginSpec.fixedPixel(0),
          topMarginSpec: charts.MarginSpec.fixedPixel(0),
          rightMarginSpec: charts.MarginSpec.fixedPixel(0),
          bottomMarginSpec:charts.MarginSpec.fixedPixel(0),
        ),
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 15));
  }
}

class BudgetData {
  int index;
  double amount;
  charts.Color color;

  BudgetData(this.index, this.amount, this.color);
}
