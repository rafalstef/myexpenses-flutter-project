import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/services/cloud/category/category.dart';

class CategoryTile extends StatelessWidget {
  final OperationCategory category;
  final Function(OperationCategory) onTap;

  const CategoryTile({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(category),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: category.color,
        child: Icon(category.icon, color: AppColors.light100),
      ),
      title: Text(
        category.name,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.regularMedium(AppColors.dark100),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }
}
