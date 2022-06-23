import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';

class NoOperations extends StatelessWidget {
  const NoOperations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.66,
      child: Center(
        child: Text(
          _noOperationMessage,
          textAlign: TextAlign.center,
          style: AppTextStyles.regularMedium(AppColors.dark20),
        ),
      ),
    );
  }

  final String _noOperationMessage =
      'There are no expenses here. Try changing the time span or accounts to find them.';
}
