import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myexpenses/utilities/money_formats.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';

typedef ExpenseCallback = void Function(Operation expense);

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    Key? key,
    required this.expense,
    required this.onTap,
  }) : super(key: key);

  final Operation expense;
  final ExpenseCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
      child: GestureDetector(
        onTap: () {
          onTap(expense);
        },
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
                        expense.category!.name.toString(),
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        expense.account!.name.toString(),
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
                      expense.category!.isIncome
                          ? '+' + moneyFormat(expense.cost)
                          : '-' + moneyFormat(expense.cost),
                      style: TextStyle(
                        color: expense.category!.isIncome
                            ? Colors.green
                            : Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(expense.date).toString(),
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
      ),
    );
  }
}
