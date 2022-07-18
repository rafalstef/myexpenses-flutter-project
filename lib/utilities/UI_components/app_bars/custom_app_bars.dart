import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';

class CustomAppBar {
  const CustomAppBar._();

  static AppBar transparent({
    required String title,
    required Color textColor,
  }) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.transparent,
      iconTheme: IconThemeData(color: textColor),
      title: Text(
        title,
        style: AppTextStyles.title3(textColor),
      ),
    );
  }
}
