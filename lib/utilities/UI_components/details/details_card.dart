import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';

class DetailsCard extends StatelessWidget {
  final Operation operation;

  const DetailsCard({Key? key, required this.operation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.94,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.light100,
        border: Border.all(color: AppColors.light20, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Table(
          children: [
            TableRow(
              children: [
                _title('Type'),
                _title('Category'),
                _title('Wallet'),
              ],
            ),
            TableRow(children: [
              _subTitle(operation.category.isIncome ? 'Income' : 'Expense'),
              _subTitle(operation.category.name),
              _subTitle(operation.account.name),
            ])
          ],
        ),
      ),
    );
  }
}

Widget _title(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Text(
      title,
      style: AppTextStyles.smallMedium(AppColors.dark20),
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    ),
  );
}

Widget _subTitle(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Text(
      text,
      style: AppTextStyles.regularSemiBold(AppColors.dark100),
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    ),
  );
}
