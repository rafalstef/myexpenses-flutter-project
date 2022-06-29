import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/multiple_choice_filter/multiple_filter_option.dart';

class OptionFilterChips extends StatelessWidget {
  final List<MultipleFilterOption> options;
  final ValueChanged<MultipleFilterOption> onOptionTap;

  const OptionFilterChips({
    required this.options,
    required this.onOptionTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: [
        ...options
            .map(
              (option) => FilterChip(
                label: Text(
                  option.name,
                  style: option.isSelected
                      ? AppTextStyles.smallMedium(AppColors.violet100)
                      : AppTextStyles.smallMedium(AppColors.dark100),
                ),
                onSelected: (_) => onOptionTap(option),
                selected: option.isSelected,
                backgroundColor: AppColors.light100,
                selectedColor: AppColors.violet20,
                checkmarkColor: AppColors.violet100,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  side: BorderSide(width: 1.0, color: AppColors.light20),
                ),
                visualDensity: const VisualDensity(vertical: 3),
              ),
            )
            .toList(),
      ],
    );
  }
}
