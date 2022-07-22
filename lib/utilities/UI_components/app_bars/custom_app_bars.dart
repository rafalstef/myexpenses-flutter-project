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

  static AppBar operationDetail({
    required Color color,
    required onTapDelete,
  }) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: color,
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => onTapDelete(),
        )
      ],
      iconTheme: const IconThemeData(color: AppColors.light100),
      title: Text(
        'Transaction Detail',
        style: AppTextStyles.title3(AppColors.light100),
      ),
    );
  }

  static SliverAppBar accountDetail({required onTapEdit}) {
    return SliverAppBar(
      title: Text(
        'Detail account',
        style: AppTextStyles.title3(AppColors.dark60),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => onTapEdit(),
        )
      ],
      elevation: 0,
      pinned: false,
      floating: true,
      centerTitle: true,
      backgroundColor: AppColors.transparent,
      iconTheme: const IconThemeData(color: AppColors.dark100),
    );
  }
}
