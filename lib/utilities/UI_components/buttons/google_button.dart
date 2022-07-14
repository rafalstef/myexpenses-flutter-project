import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/UI_components/buttons/large_buttons.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final ButtonCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => onPressed(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/google_logo.png',
            width: 32.0,
            height: 32.0,
          ),
          const SizedBox(width: 8.0),
          Text(text, style: AppTextStyles.title3(AppColors.dark60)),
        ],
      ),
      style: OutlinedButton.styleFrom(
        elevation: 0,
        primary: AppColors.light100,
        fixedSize: Size(MediaQuery.of(context).size.width, 54),
        side: const BorderSide(color: AppColors.light20, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
