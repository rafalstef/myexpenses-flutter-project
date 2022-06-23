import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/UI_components/buttons/pills.dart';

class SeeAllBar extends StatelessWidget {
  const SeeAllBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transaction',
              style: AppTextStyles.title3(AppColors.dark60),
            ),
            PrimaryPill(
              text: 'See All',
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
