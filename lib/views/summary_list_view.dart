import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:myexpenses/services/cloud/expense/expense.dart';
import 'package:myexpenses/views/background.dart';
import 'package:myexpenses/views/expense_card.dart';

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

    final headerList = ListView.builder(
      itemBuilder: (context, index) {
        EdgeInsets padding = index == 0
            ? const EdgeInsets.only(
                left: 20.0, right: 10.0, top: 4.0, bottom: 30.0)
            : const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 4.0, bottom: 30.0);

        return Padding(
          padding: padding,
          child: InkWell(
            onTap: () {
              // print('Card selected');
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.lightGreen,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(70),
                      offset: const Offset(3.0, 10.0),
                      blurRadius: 15.0)
                ],
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://theminimalistvegan.com/wp-content/uploads/2021/06/Minimalist-family-transition-period.001.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              width: 200.0,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Color(0xFF273A48),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0))),
                        height: 30.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: <Widget>[
                            const Text(
                              'here will be diagram title',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        );
      },
      scrollDirection: Axis.horizontal,
    );

    final body = Scaffold(
      appBar: AppBar(
        title: Text('Your total balance: ' +
            MoneyFormatter(
              amount: _loopResult().toDouble(),
              settings: MoneyFormatterSettings(
                thousandSeparator: ' ',
                decimalSeparator: '.',
                symbol: 'PLN',
              ),
            )
                .fastCalc(
                  type: FastCalcType.addition,
                  amount: _loopResult().toDouble(),
                )
                .fastCalc(
                    type: FastCalcType.substraction,
                    amount: _loopResult().toDouble())
                .output
                .symbolOnRight),
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
                SizedBox(height: 300.0, width: _width, child: headerList),
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
    return (expenses.isEmpty)
        ? const Text('Add your first expense')
        : ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses.elementAt(index);
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
