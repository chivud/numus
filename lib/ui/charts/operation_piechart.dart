import 'package:charts_flutter/flutter.dart' as Charts;
import 'package:flutter/material.dart';
import 'package:numus/entities/charts/operations_summary.dart';
import 'package:numus/entities/settings.dart';

class OperationPieChart extends StatelessWidget {
  final List<OperationSummary> list;
  final String id;
  final Settings settings;

  OperationPieChart(this.list, this.id, this.settings);

  List<Charts.Series<OperationSummary, String>> getSeries(
      List<OperationSummary> items) {
    return [
      Charts.Series<OperationSummary, String>(
          id: id,
          data: items,
          domainFn: (OperationSummary op, _) => op.category.name,
          measureFn: (OperationSummary op, _) => op.amount,
          labelAccessorFn: (OperationSummary op, _) => op.category.name,
          colorFn: (OperationSummary op, _) {
            Color color = Color(op.category.color);
            return Charts.Color(
                r: color.red, g: color.green, b: color.blue, a: color.alpha);
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (list.isNotEmpty) {
      return Charts.PieChart(
        getSeries(list),
        animate: true,
        defaultRenderer:
            Charts.ArcRendererConfig(arcWidth: 100, arcRendererDecorators: [
          Charts.ArcLabelDecorator(),
        ]),
        behaviors: [
          Charts.DatumLegend(
            desiredMaxColumns: 2,
            showMeasures: true,
            legendDefaultMeasure: Charts.LegendDefaultMeasure.firstValue,
            measureFormatter: (value) =>
                value.toString() + ' ' + settings.currency.symbol,
          )
        ],
      );
    }
    return Center(
      child: Text('No data for this time range.'),
    );
  }
}
