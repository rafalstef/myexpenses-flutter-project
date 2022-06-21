import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/UI_components/buttons/large_buttons.dart';

class Pill extends StatelessWidget {
  final String text;
  final ButtonCallback onPressed;

  const Pill({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppColors.violet20,
        elevation: 0,
        fixedSize: const Size(78.0, 32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
      ),
      onPressed: () => onPressed,
      child: Text(
        text,
        style: AppTextStyles.smallSemiBold(AppColors.violet100),
      ),
    );
  }
}
