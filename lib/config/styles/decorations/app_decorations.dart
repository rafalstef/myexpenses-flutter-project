import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';

part 'app_decorations_input.dart';
part 'app_decorations_buttons.dart';

class AppDecorations {
  const AppDecorations._();

  static BoxDecoration homePageGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [AppColors.yellow20, AppColors.light100],
      ),
    );
  }
}
