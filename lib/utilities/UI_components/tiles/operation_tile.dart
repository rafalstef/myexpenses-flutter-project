import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/UI_components/icons_containers/icon_container.dart';
import 'package:myexpenses/utilities/formats/money_formats.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';

typedef OperationCallback = void Function(Operation expense);

class OperationTile extends StatelessWidget {
  const OperationTile({
    Key? key,
    required this.operation,
    required this.onTap,
  }) : super(key: key);

  final Operation operation;
  final OperationCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => onTap(operation),
        leading: TileIcon(
          icon: operation.category.icon,
          iconColor: operation.category.color,
          containerColor: operation.category.color.withOpacity(0.1),
        ),
        title: operationCategoryName(),
        subtitle: operationTitle(),
        trailing: operationCost(),
        tileColor: AppColors.light90,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
      ),
    );
  }

  Text operationCategoryName() {
    return Text(
      operation.category.name.toString(),
      style: AppTextStyles.regularMedium(AppColors.dark60),
      overflow: TextOverflow.ellipsis,
    );
  }

  Text operationTitle() {
    return Text(
      'Some groceries',
      style: AppTextStyles.small(AppColors.dark20),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget operationCost() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          operation.category.isIncome
              ? '+' + moneyFormat(operation.cost)
              : '-' + moneyFormat(operation.cost),
          style: operation.category.isIncome
              ? AppTextStyles.regularSemiBold(AppColors.green100)
              : AppTextStyles.regularSemiBold(AppColors.red100),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
