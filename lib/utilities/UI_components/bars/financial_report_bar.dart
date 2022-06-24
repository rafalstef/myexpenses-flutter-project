import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';

class FinancialReportBar extends StatefulWidget {
  const FinancialReportBar({Key? key}) : super(key: key);

  @override
  State<FinancialReportBar> createState() => _FinancialReportBarState();
}

class _FinancialReportBarState extends State<FinancialReportBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ElevatedButton(
          onPressed: () => {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('See your financial report',
                  style: AppTextStyles.regular(AppColors.violet100)),
              const Icon(
                Icons.keyboard_arrow_right_rounded,
                size: 40,
                color: AppColors.violet100,
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: AppColors.violet20,
            fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
