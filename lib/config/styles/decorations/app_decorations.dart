import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';

part 'app_decorations_input.dart';
part 'app_decorations_buttons.dart';

class AppDecorations {
  const AppDecorations._();

  static const _Button button = _Button();
  static const _Input input = _Input();

  static BoxDecoration homePageGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [AppColors.yellow20, AppColors.light100],
      ),
    );
  }

  static BoxDecoration bottomSheetDecoration() {
    return const BoxDecoration(
      color: AppColors.light100,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
    );
  }

  static BoxDecoration newTransactionDecoration() {
    return const BoxDecoration(
      color: AppColors.light100,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.0),
        topRight: Radius.circular(32.0),
      ),
    );
  }
}
