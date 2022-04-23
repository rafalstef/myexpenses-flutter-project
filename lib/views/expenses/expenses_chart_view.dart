import 'package:flutter/material.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/expense/expense.dart';
import 'package:myexpenses/services/cloud/expense/firebase_expense.dart';
import 'package:myexpenses/views/chart/chart_data.dart';
import 'package:myexpenses/views/chart/chart_view.dart';
import "package:collection/collection.dart";

class ExpensesPieChart extends StatefulWidget {
  const ExpensesPieChart({Key? key}) : super(key: key);

  @override
  State<ExpensesPieChart> createState() => _ExpensesPieChartState();
}

class _ExpensesPieChartState extends State<ExpensesPieChart> {
  late final FirebaseExpense _firebaseExpense;
  late final Future? myFuture = getChartData();
  late final List<ChartData> _chartData = List<ChartData>.empty(growable: true);
  late double expensesSum;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _firebaseExpense = FirebaseExpense();
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
                appBar: AppBar(title: const Text('Expenses chart')),
                body: OperationChart(
                  chartData: _chartData,
                  operationsSum: expensesSum,
                ),
              );
            default:
              return Scaffold(
                appBar: AppBar(title: const Text('Expenses chart')),
                body: const Center(child: CircularProgressIndicator()),
              );
          }
        });
  }

  Future<void> getChartData() async {
    Iterable<Expense> allExpenses =
        await _firebaseExpense.getExpensesWithoutIncomes(ownerUserId: userId);
    allExpenses = allExpenses.toList();

    // group by expense category name
    final groupedList =
        groupBy(allExpenses, (Expense expense) => expense.category!.name);

    double sum;
    expensesSum = 0;

    groupedList.forEach((key, value) {
      sum = 0;
      // iterate over list of expenses
      for (var element in value) {
        sum += element.cost;
      }
      expensesSum += sum;
      _chartData.add(ChartData(key, sum));
    });
  }
}
