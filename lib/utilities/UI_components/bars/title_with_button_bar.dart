import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/UI_components/buttons/large_buttons.dart';
import 'package:myexpenses/utilities/UI_components/buttons/pills.dart';

class TitleWithButtonBar extends StatelessWidget {
  final String title;
  final String buttonTitle;
  final ButtonCallback onPressed;

  const TitleWithButtonBar({
    Key? key,
    required this.title,
    required this.buttonTitle,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.title3(AppColors.dark60),
          ),
          PrimaryPill(
            text: buttonTitle,
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
