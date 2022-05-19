import 'package:flutter/material.dart';
import 'package:myexpenses/utilities/formats/money_formats.dart';

class HomePageTopCards extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const HomePageTopCards({
    Key? key,
    required this.balance,
    required this.expense,
    required this.income,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          balanceCard(context),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              incomeExpenseCard(context, true),
              incomeExpenseCard(context, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget balanceCard(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: homeCardsBoxDecoration(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('TOTAL BALANCE', style: getNamesTextStyle()),
            const SizedBox(height: 6),
            (balance > 0)
                ? Text(
                    '+' + moneyFormat(balance),
                    style: getCostsTextStyle(Colors.green),
                  )
                : Text(
                    moneyFormat(balance),
                    style: getCostsTextStyle(Colors.red),
                  ),
          ],
        ),
      ),
    );
  }

  Widget incomeExpenseCard(BuildContext context, bool isIncome) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 10),
      height: 80,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: homeCardsBoxDecoration(),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                isIncome ? "TOTAL INCOME" : "TOTAL EXPENSE",
                style: getNamesTextStyle(),
              ),
              const SizedBox(height: 6),
              (isIncome)
                  ? Text(
                      ('+' + moneyFormat(income)),
                      style: getCostsTextStyle(Colors.green),
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text(
                      ('-' + moneyFormat(expense)),
                      style: getCostsTextStyle(Colors.red),
                      overflow: TextOverflow.ellipsis,
                    )
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              radius: 14,
              child: Icon(
                isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                color: isIncome ? Colors.green : Colors.red,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle getNamesTextStyle() {
    return const TextStyle(
      color: Colors.grey,
      fontSize: 9,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle getCostsTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  BoxDecoration homeCardsBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    );
  }
}
