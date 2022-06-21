import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/formats/money_formats.dart';

class HomePageMiniCard extends StatelessWidget {
  const HomePageMiniCard({
    Key? key,
    required this.amount,
    required this.text,
    required this.icon,
    required this.color,
  }) : super(key: key);

  final double amount;
  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: 74,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: color,
      ),
      child: Row(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: AppColors.light100,
              ),
              child: Icon(
                icon,
                color: color,
                size: 28.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: AppTextStyles.smallMedium(AppColors.light80),
                ),
                const SizedBox(height: 4),
                Text(
                  moneyFormat(amount),
                  style: AppTextStyles.title3(AppColors.light80),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
