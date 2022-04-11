import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    Key? key,
    required this.categoryName,
    required this.accountName,
    required this.isIncome,
    required this.date,
    required this.cost,
  }) : super(key: key);

  final String categoryName;
  final String accountName;
  final bool isIncome;
  final DateTime date;
  final double cost;

  @override
  Widget build(BuildContext context) {
    final _costFormat = MoneyFormatter(
      amount: cost,
      settings: MoneyFormatterSettings(
        thousandSeparator: ' ',
        decimalSeparator: '.',
        symbol: 'PLN',
      ),
    ).output.symbolOnRight;

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryName,
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      accountName,
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isIncome ? '+' + _costFormat : '-' + _costFormat,
                    style: TextStyle(
                      color: isIncome ? Colors.green : Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('yyyy-mm-dd').format(date).toString(),
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
