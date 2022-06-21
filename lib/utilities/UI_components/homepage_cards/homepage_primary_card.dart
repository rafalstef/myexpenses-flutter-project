import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/formats/money_formats.dart';

class HomePagePrimaryCard extends StatelessWidget {
  const HomePagePrimaryCard({
    Key? key,
    required this.text,
    required this.amount,
  }) : super(key: key);

  final String text;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      color: AppColors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Total Balance',
              style: TextStyle(color: Color(0xFF91919f), fontSize: 12),
            ),
            const SizedBox(height: 16),
            Text(
              moneyFormat(amount),
              style: AppTextStyles.title1(AppColors.dark80),
            )
          ],
        ),
      ),
    );
  }
}
