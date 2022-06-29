import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/one_choice_filter/filter_option.dart';

class OptionChoiceChips extends StatelessWidget {
  const OptionChoiceChips({
    required this.selectedOptionId,
    required this.onOptionTap,
    required this.options,
    Key? key,
  }) : super(key: key);

  final List<FilterOption> options;
  final dynamic selectedOptionId;
  final ValueChanged<FilterOption> onOptionTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: [
        ...options.map(
          (option) {
            final isItemSelected = selectedOptionId == option.id;
            return ChoiceChip(
              label: Text(
                option.name,
                style: isItemSelected
                    ? AppTextStyles.smallMedium(AppColors.violet100)
                    : AppTextStyles.smallMedium(AppColors.dark100),
              ),
              onSelected: (_) => onOptionTap(option),
              selected: isItemSelected,
              backgroundColor: AppColors.light100,
              selectedColor: AppColors.violet20,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                side: BorderSide(width: 1.0, color: AppColors.light20),
              ),
              visualDensity: const VisualDensity(vertical: 3),
            );
          },
        ).toList(),
      ],
    );
  }
}
