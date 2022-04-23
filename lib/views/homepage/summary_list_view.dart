import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/utilities/money_formats.dart';
import 'package:myexpenses/services/cloud/expense/expense.dart';
import 'package:myexpenses/views/homepage/background.dart';
import 'package:myexpenses/views/expenses/expense_card.dart';

class SummaryListView extends StatelessWidget {
  final Iterable<Expense> expenses;
  final Iterable<Account> accounts;

  const SummaryListView({
    Key? key,
    required this.accounts,
    required this.expenses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final body = Scaffold(
      appBar: AppBar(
        title: Text('Your total balance: ' + moneyFormat(_loopResult())),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: const <Widget>[],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                  ),
                ),
                Expanded(child: getExpensesListView()),
              ],
            ),
          ),
        ],
      ),
    );

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF273A48),
      ),
      child: Stack(
        children: <Widget>[
          CustomPaint(
            size: Size(_width, _height),
            painter: Background(),
          ),
          body,
        ],
      ),
    );
  }

  Widget getExpensesListView() {
    final expensesList = expenses.toList();
    expensesList.sort((a, b) => b.date.compareTo(a.date));
    return (expensesList.isEmpty)
        ? const Center(
            child: Text(
            'Add your first expense',
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ))
        : ListView.builder(
            itemCount: expensesList.length,
            itemBuilder: (context, index) {
              final expense = expensesList.elementAt(index);
              return ExpenseCard(
                expense: expense,
                onTap: (expense) {
                  Navigator.of(context).pushNamed(
                    createOrUpdateExpenseRoute,
                    arguments: expense,
                  );
                },
              );
            });
  }

  double _loopResult() {
    double sumup = 0;
    for (int i = 0; i < accounts.length; i++) {
      final account = accounts.elementAt(i);
      if (account.includeInBalance) {
        sumup = sumup + account.amount;
      }
    }
    return sumup;
  }
}
