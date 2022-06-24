import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/formats/date_formats.dart';

class GroupedOperationsLabelBar extends StatelessWidget {
  final String label;

  const GroupedOperationsLabelBar({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            weekdayMonthDay(toDate(label)),
            style: AppTextStyles.title3(AppColors.dark80),
          ),
        ),
      ),
    );
  }
}
