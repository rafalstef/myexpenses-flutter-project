import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';

typedef ButtonCallback = VoidCallback;

class LargePrimaryButton extends StatelessWidget {
  const LargePrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final ButtonCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(
        text,
        style: AppTextStyles.title3(AppColors.light80),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        primary: AppColors.violet100,
        fixedSize: Size(MediaQuery.of(context).size.width, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}

class LargeSecondaryButton extends StatelessWidget {
  const LargeSecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final ButtonCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(
        text,
        style: AppTextStyles.title3(AppColors.violet100),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        primary: AppColors.violet20,
        fixedSize: Size(MediaQuery.of(context).size.width, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
