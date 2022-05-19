import 'package:flutter/material.dart';
import 'package:myexpenses/utilities/formats/money_formats.dart';
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
    return GestureDetector(
      onTap: () => onTap(expense),
      child: Container(
        height: 40,
        margin: const EdgeInsets.fromLTRB(4, 5, 4, 5),
        decoration: expenseCardBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              operationCategoryName(),
              operationDate(),
            ],
          ),
        ),
      ),
    );
  }

  Text operationCategoryName() {
    return Text(
      expense.category!.name.toString(),
      style: TextStyle(
        color: Colors.grey[900],
        fontSize: 15,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Text operationDate() {
    return Text(
      expense.category!.isIncome
          ? '+' + moneyFormat(expense.cost)
          : '-' + moneyFormat(expense.cost),
      style: TextStyle(
        color: expense.category!.isIncome ? Colors.green : Colors.red,
        fontSize: 15,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  BoxDecoration expenseCardBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 5,
        ),
      ],
    );
  }
}
