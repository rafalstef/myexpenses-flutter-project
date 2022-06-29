import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/one_choice_filter/filter_option.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/one_choice_filter/option_choice_chips.dart';

class OneChoiceFilterGroup extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<FilterOption> options;
  final dynamic selectedOptionId;
  final ValueChanged<FilterOption> onOptionTap;

  const OneChoiceFilterGroup({
    required this.title,
    required this.icon,
    required this.options,
    required this.selectedOptionId,
    required this.onOptionTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.regularSemiBold(AppColors.dark100),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          OptionChoiceChips(
            options: options,
            selectedOptionId: selectedOptionId,
            onOptionTap: onOptionTap,
          ),
        ],
      ),
    );
  }
}
