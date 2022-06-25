import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';

class NoOperations extends StatelessWidget {
  const NoOperations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.66,
      height: MediaQuery.of(context).size.height * 0.4,
      alignment: Alignment.center,
      child: Text(
        _noOperationMessage,
        textAlign: TextAlign.center,
        style: AppTextStyles.regularMedium(AppColors.dark20),
        overflow: TextOverflow.clip,
      ),
    );
  }

  final String _noOperationMessage = 'There are no transactions here.';
}
