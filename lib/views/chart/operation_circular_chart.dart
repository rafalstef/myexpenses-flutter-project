import 'package:flutter/material.dart';
import 'package:myexpenses/utilities/formats/money_formats.dart';
import 'package:myexpenses/views/chart/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OperationCircularChart extends StatefulWidget {
  final List<ChartData> chartData;
  final double operationsSum;
  final Function(String?) onTapCategorySegment;

  const OperationCircularChart({
    Key? key,
    required this.chartData,
    required this.operationsSum,
    required this.onTapCategorySegment,
  }) : super(key: key);

  @override
  State<OperationCircularChart> createState() => _OperationCircularChartState();
}

class _OperationCircularChartState extends State<OperationCircularChart> {
  int currentSegmentIndex = -1;
  String categoryName = 'All categories';
  late double categoryCost = widget.operationsSum;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: SfCircularChart(
            annotations: [_chartAnnotation()],
            legend: _chartLegend(),
            series: <CircularSeries>[_operationDoughnutSeries()],
          ),
        ),
      ),
      const SizedBox(height: 40),
      Row(
        children: [
          _getCategoryNameColumn(),
          const SizedBox(width: 40),
          _getCategoryValueColumn(),
        ],
      ),
    ]);
  }

  CircularChartAnnotation _chartAnnotation() {
    return CircularChartAnnotation(
      widget: Text(
        moneyFormat(widget.operationsSum),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Legend _chartLegend() {
    return Legend(
      isVisible: true,
      overflowMode: LegendItemOverflowMode.wrap,
      position: LegendPosition.bottom,
    );
  }

  DoughnutSeries<ChartData, String> _operationDoughnutSeries() {
    return DoughnutSeries<ChartData, String>(
      radius: '60%',
      innerRadius: '80%',
      dataSource: widget.chartData,
      xValueMapper: (ChartData data, _) => data.category,
      yValueMapper: (ChartData data, _) => data.value,
      dataLabelMapper: (ChartData data, _) => moneyFormat(data.value),
      dataLabelSettings: _dataLabelSettings(),
      onPointTap: (ChartPointDetails details) => _segmentTap(details),
      selectionBehavior: SelectionBehavior(enable: true),
      animationDuration: 0.0,
    );
  }

  DataLabelSettings _dataLabelSettings() {
    return const DataLabelSettings(
      isVisible: true,
      labelAlignment: ChartDataLabelAlignment.top,
      labelIntersectAction: LabelIntersectAction.shift,
      labelPosition: ChartDataLabelPosition.outside,
      connectorLineSettings:
          ConnectorLineSettings(type: ConnectorType.curve, length: '25%'),
    );
  }

  void _segmentTap(ChartPointDetails details) {
    currentSegmentIndex =
        (currentSegmentIndex == details.pointIndex!) ? -1 : details.pointIndex!;
    if (currentSegmentIndex == -1) {
      categoryName = 'All categories';
      categoryCost = widget.operationsSum;
      widget.onTapCategorySegment(null);
    } else {
      categoryName = details.dataPoints![details.pointIndex!].x.toString();
      categoryCost = details.dataPoints![details.pointIndex!].y;
      widget.onTapCategorySegment(categoryName);
    }
    setState(() {});
  }

  Expanded _getCategoryValueColumn() {
    return Expanded(
      flex: 1,
      child: Text(
        moneyFormat(categoryCost) +
            '\n' +
            ((categoryCost == 0)
                ? '100 %'
                : (categoryCost / widget.operationsSum * 100)
                        .roundToDouble()
                        .toStringAsFixed(0) +
                    ' %'),
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Expanded _getCategoryNameColumn() {
    return Expanded(
      flex: 1,
      child: Text(
        categoryName,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black87,
        ),
      ),
    );
  }
}
