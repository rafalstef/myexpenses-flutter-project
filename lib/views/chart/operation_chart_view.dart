import 'package:flutter/material.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/views/chart/chart_data.dart';
import 'package:myexpenses/views/chart/operation_circular_chart.dart';
import "package:collection/collection.dart";

class OperationChartView extends StatefulWidget {
  final String title;
  final List<Operation> operations;
  final Function(String?) onTapCategorySegment;

  const OperationChartView({
    Key? key,
    required this.title,
    required this.operations,
    required this.onTapCategorySegment,
  }) : super(key: key);

  @override
  State<OperationChartView> createState() => _OperationChartViewState();
}

class _OperationChartViewState extends State<OperationChartView>
    with AutomaticKeepAliveClientMixin<OperationChartView> {
  final List<ChartData> _chartData = List<ChartData>.empty(growable: true);
  double operationsSum = 0;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  get wantKeepAlive => true;

  @override
  void initState() {
    _getChartData();
    super.initState();
  }

  @override
  void didUpdateWidget(OperationChartView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.operations != widget.operations) {
      updateChildWithParent();
    }
  }

  void updateChildWithParent() {
    _chartData.clear();
    operationsSum = 0;
    if (widget.operations.isNotEmpty) {
      _getChartData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("CHART REBUILD");
    super.build(context);
    return Column(
      children: [
        _pageTitle(),
        OperationCircularChart(
          chartData: _chartData,
          operationsSum: operationsSum,
          onTapCategorySegment: widget.onTapCategorySegment,
        ),
      ],
    );
  }

  void _getChartData() {
    final operations = widget.operations;
    // group by operation category name
    final groupedList =
        groupBy(operations, (Operation operation) => operation.category.name);

    double sum;

    groupedList.forEach((key, value) {
      sum = 0;
      // iterate over list of operations
      for (var element in value) {
        sum += element.cost;
      }
      operationsSum += sum;
      _chartData.add(ChartData(key, sum));
    });
  }

  Widget _pageTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Text(
        widget.title,
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
