import 'package:flutter/material.dart';
import 'package:myexpenses/utilities/money_formats.dart';
import 'package:myexpenses/views/chart/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OperationChart extends StatefulWidget {
  final List<ChartData> chartData;
  final double operationsSum;

  const OperationChart({
    Key? key,
    required this.chartData,
    required this.operationsSum,
  }) : super(key: key);

  @override
  State<OperationChart> createState() => _OperationChartState();
}

class _OperationChartState extends State<OperationChart> {
  int currentSegmentIndex = -1;
  String categoryName = 'All categories';
  late double categoryCost = widget.operationsSum;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SafeArea(
        child: SizedBox(
          height: 350,
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
      innerRadius: '80%',
      dataSource: widget.chartData,
      xValueMapper: (ChartData data, _) => data.category,
      yValueMapper: (ChartData data, _) => data.value,
      dataLabelMapper: (ChartData data, _) => moneyFormat(data.value),
      dataLabelSettings: _dataLabelSettings(),
      onPointTap: (ChartPointDetails details) => _segmentTap(details),
      selectionBehavior: SelectionBehavior(enable: true),
    );
  }

  DataLabelSettings _dataLabelSettings() {
    return const DataLabelSettings(
      isVisible: true,
      labelIntersectAction: LabelIntersectAction.shift,
      labelPosition: ChartDataLabelPosition.outside,
      overflowMode: OverflowMode.trim,
    );
  }

  void _segmentTap(ChartPointDetails details) {
    currentSegmentIndex =
        (currentSegmentIndex == details.pointIndex!) ? -1 : details.pointIndex!;
    categoryName = (currentSegmentIndex == -1)
        ? 'All categories'
        : details.dataPoints![details.pointIndex!].x.toString();
    categoryCost = (currentSegmentIndex == -1)
        ? widget.operationsSum
        : details.dataPoints![details.pointIndex!].y;
    setState(() {});
  }

  Expanded _getCategoryValueColumn() {
    return Expanded(
      flex: 1,
      child: Text(
        moneyFormat(categoryCost) +
            '\n' +
            (categoryCost / widget.operationsSum * 100)
                .roundToDouble()
                .toStringAsFixed(0) +
            ' %',
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
