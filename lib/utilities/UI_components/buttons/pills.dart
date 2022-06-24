import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/UI_components/buttons/large_buttons.dart';

class PrimaryPill extends StatelessWidget {
  final String text;
  final ButtonCallback onPressed;

  const PrimaryPill({
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

class SecondaryPill extends StatelessWidget {
  final String text;
  final ButtonCallback onPressed;

  const SecondaryPill({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 8.0, right: 16.0),
        primary: AppColors.light100,
        side: const BorderSide(color: AppColors.light60, width: 2.0),
        elevation: 0,
        minimumSize: const Size(78.0, 32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
      ),
      onPressed: () => onPressed(),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.violet100,
      ),
      label: Text(
        text,
        style: AppTextStyles.smallSemiBold(AppColors.dark60),
      ),
    );
  }
}
