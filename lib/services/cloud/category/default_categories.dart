import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/services/cloud/category/category.dart';

class DefaultCategories {
  const DefaultCategories._();

  static List<OperationCategory> defaultCategoryList() {
    return const [
      OperationCategory(
        documentId: '',
        name: 'Health',
        isIncome: false,
        color: AppColors.green100,
        icon: Icons.health_and_safety_rounded,
      ),
      OperationCategory(
        documentId: '',
        name: 'Home',
        isIncome: false,
        color: AppColors.blue100,
        icon: Icons.home_rounded,
      ),
      OperationCategory(
        documentId: '',
        name: 'Restaurant',
        isIncome: false,
        color: AppColors.red100,
        icon: Icons.health_and_safety_rounded,
      ),
      OperationCategory(
        documentId: '',
        name: 'Supermarket',
        isIncome: false,
        color: AppColors.yellow100,
        icon: Icons.shopping_cart_rounded,
      ),
      OperationCategory(
        documentId: '',
        name: 'Transportation',
        isIncome: false,
        color: AppColors.violet100,
        icon: Icons.emoji_transportation_rounded,
      ),
      OperationCategory(
        documentId: '',
        name: 'Travel',
        isIncome: false,
        color: AppColors.light100,
        icon: Icons.travel_explore_rounded,
      ),
      OperationCategory(
        documentId: '',
        name: 'Salary',
        isIncome: true,
        color: AppColors.blue100,
        icon: Icons.money_rounded,
      ),
    ];
  }
}
