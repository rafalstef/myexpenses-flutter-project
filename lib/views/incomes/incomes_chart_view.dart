import 'package:flutter/material.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/services/cloud/operation/firebase_operation.dart';
import 'package:myexpenses/views/chart/chart_data.dart';
import 'package:myexpenses/views/chart/chart_view.dart';
import "package:collection/collection.dart";
import 'package:myexpenses/views/navBar.dart';

class IncomesPieChart extends StatefulWidget {
  const IncomesPieChart({Key? key}) : super(key: key);

  @override
  State<IncomesPieChart> createState() => _IncomesPieChartState();
}

class _IncomesPieChartState extends State<IncomesPieChart> {
  late final FirebaseOperation _firebaseOperation;
  late final Future? myFuture = getChartData();
  late final List<ChartData> _chartData = List<ChartData>.empty(growable: true);
  late double operationsSum;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _firebaseOperation = FirebaseOperation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Scaffold(
                drawer: const SideDrawer(),
                appBar: AppBar(title: const Text('Incomes chart')),
                body: OperationChart(
                  chartData: _chartData,
                  operationsSum: operationsSum,
                ),
              );
            default:
              return Scaffold(
                appBar: AppBar(title: const Text('Incomes chart')),
                body: const Center(child: CircularProgressIndicator()),
              );
          }
        });
  }

  Future<void> getChartData() async {
    Iterable<Operation> allOperations =
        await _firebaseOperation.getIncomeOperations(ownerUserId: userId);
    allOperations = allOperations.toList();

    // group by operation category name
    final groupedList = groupBy(
        allOperations, (Operation operation) => operation.category!.name);

    double sum;
    operationsSum = 0;

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
}
