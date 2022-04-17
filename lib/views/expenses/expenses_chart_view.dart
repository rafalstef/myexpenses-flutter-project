import 'package:flutter/material.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/expense/expense.dart';
import 'package:myexpenses/services/cloud/expense/firebase_expense.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import "package:collection/collection.dart";

class ExpensesPieChart extends StatefulWidget {
  const ExpensesPieChart({Key? key}) : super(key: key);

  @override
  State<ExpensesPieChart> createState() => _ExpensesPieChartState();
}

class _ExpensesPieChartState extends State<ExpensesPieChart> {
  late final FirebaseExpense _firebaseExpense;
  late final List<ChartExpense> _chartData =
      List<ChartExpense>.empty(growable: true);
  late final TooltipBehavior _tooltipBehavior;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _firebaseExpense = FirebaseExpense();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  Future<void> getChartData() async {
    Iterable<Expense> allExpenses =
        await _firebaseExpense.getExpensesWithoutIncomes(ownerUserId: userId);
    allExpenses = allExpenses.toList();

    // group by expense category name
    final groupedList =
        groupBy(allExpenses, (Expense expense) => expense.category!.name);

    double sum;
    groupedList.forEach((key, value) {
      sum = 0;
      // iterate over list of expenses
      for (var element in value) {
        sum += element.cost;
      }
      _chartData.add(ChartExpense(key, sum));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getChartData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Scaffold(
                appBar: AppBar(title: const Text('Expenses chart')),
                body: SafeArea(
                  child: Scaffold(
                    body: SfCircularChart(
                      title: ChartTitle(text: 'Expenses Pie Chart'),
                      legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),
                      tooltipBehavior: _tooltipBehavior,
                      series: <CircularSeries>[
                        PieSeries<ChartExpense, String>(
                          dataSource: _chartData,
                          xValueMapper: (ChartExpense data, _) => data.category,
                          yValueMapper: (ChartExpense data, _) => data.value,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                          enableTooltip: true,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}

class ChartExpense {
  ChartExpense(this.category, this.value);
  final String category;
  final double value;
}
