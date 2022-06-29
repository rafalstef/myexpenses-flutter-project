import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/multiple_choice_filter/multiple_filter_option.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/multiple_choice_filter/option_filter_chips.dart';

class MultipleChoiceFilterGroup extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<MultipleFilterOption> options;
  final ValueChanged<MultipleFilterOption> onOptionTap;

  const MultipleChoiceFilterGroup({
    required this.title,
    required this.icon,
    required this.options,
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
          OptionFilterChips(
            options: options,
            onOptionTap: onOptionTap,
          ),
        ],
      ),
    );
  }
}
