import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as Charts;
import 'package:intl/intl.dart';
import 'package:numus/constants/date.dart';
import 'package:numus/entities/charts/type_summary.dart';
import 'package:numus/ui/charts/operation_chart.dart';
import 'package:charts_flutter/src/text_element.dart'; // ignore: implementation_imports
import 'package:charts_flutter/src/text_style.dart' // ignore: implementation_imports
    as style;

class OperationLineChart extends OperationChart {
  final List<TypeSummary> list;
  final String id;

  OperationLineChart(this.list, this.id);

  List<Charts.Series<TypeSummary, DateTime>> getSeries() {
    return [
      Charts.Series<TypeSummary, DateTime>(
        id: id,
        colorFn: (_, __) => Charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TypeSummary ts, _) => ts.date,
        measureFn: (TypeSummary ts, _) => ts.amount,
        data: list,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    CustomCircleSymbolRenderer render = CustomCircleSymbolRenderer();
    if (list.isNotEmpty) {
      return Container(
        padding: EdgeInsets.all(5),
        child: Charts.TimeSeriesChart(
          getSeries(),
          behaviors: [Charts.LinePointHighlighter(symbolRenderer: render)],
          selectionModels: [
            Charts.SelectionModelConfig(
                changedListener: (Charts.SelectionModel model) {
              if (model.hasDatumSelection) {
                TypeSummary summary = model.selectedDatum.first.datum;
                render.amount = summary.amount;
                render.date = summary.date;
              }
            })
          ],
        ),
      );
    }
    return Center(
      child: Text('No data for this time range.'),
    );
  }
}

///This is a hack. Might not work in the future
class CustomCircleSymbolRenderer extends Charts.CircleSymbolRenderer {
  DateTime date;
  double amount;
  DateFormat formatter = DateFormat(monthDayFormat);

  @override
  void paint(Charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      Charts.Color fillColor,
      Charts.FillPatternType fillPattern,
      Charts.Color strokeColor,
      double strokeWidthPx}) {
    final center = Point(
      bounds.left + (bounds.width / 2),
      bounds.top + (bounds.height / 2),
    );
    final radius = min(bounds.width, bounds.height) / 2;
    canvas.drawPoint(
        point: center,
        radius: radius,
        fill: getSolidFillColor(fillColor),
        stroke: strokeColor,
        strokeWidthPx: getSolidStrokeWidthPx(strokeWidthPx));
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top - 52, bounds.width + 55,
            bounds.height + 35),
        fill: Charts.Color.white,
        stroke: Charts.Color.fromHex(code: "#B8B8B8"),
        strokeWidthPx: 1);
    var textStyle = style.TextStyle();
    textStyle.color = Charts.Color.black;
    textStyle.fontSize = 15;
    canvas.drawText(TextElement("$amount", style: textStyle),
        (bounds.left).round(), (bounds.top - 28).round());
    canvas.drawText(TextElement(formatter.format(date), style: textStyle),
        (bounds.left).round(), (bounds.top - 50).round());
    super.paint(canvas, bounds);
  }
}
