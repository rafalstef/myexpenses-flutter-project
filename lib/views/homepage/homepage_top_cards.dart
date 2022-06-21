import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/utilities/UI_components/homepage_cards/homepage_mini_card.dart';
import 'package:myexpenses/utilities/UI_components/homepage_cards/homepage_primary_card.dart';

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
          HomePagePrimaryCard(text: 'Balance', amount: balance),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HomePageMiniCard(
                amount: income,
                text: 'Income',
                icon: Icons.arrow_upward,
                color: AppColors.green100,
              ),
              HomePageMiniCard(
                amount: expense,
                text: 'Expense',
                icon: Icons.arrow_downward,
                color: AppColors.red100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
