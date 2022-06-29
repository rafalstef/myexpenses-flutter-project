import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/list_filter.dart/filter_list_option.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/list_filter.dart/option_list.dart';

class FilterListGroup extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<FilterListOption> options;
  final Iterable<String> selectedOptions;
  final ValueChanged<List<String>> onOptionTap;

  const FilterListGroup({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.options,
    required this.selectedOptions,
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
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              onOptionTap(
                await _selectOptionsFromList(
                  context: context,
                  options: options,
                  selectedOptions: selectedOptions,
                ),
              );
            },
            child: _buildListButton(context: context),
          )
        ],
      ),
    );
  }

  Future<List<String>> _selectOptionsFromList({
    required BuildContext context,
    required List<FilterListOption> options,
    required Iterable<String> selectedOptions,
  }) async =>
      await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return OptionList(
            listTitle: title,
            options: options,
            selectedOptions: selectedOptions,
          );
        },
      );

  SizedBox _buildListButton({required BuildContext context}) {
    return SizedBox(
      height: 56.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subtitle,
            style: AppTextStyles.regularMedium(AppColors.dark60),
          ),
          Row(
            children: [
              Text(
                '${selectedOptions.length} selected',
                style: AppTextStyles.smallMedium(AppColors.dark20),
              ),
              const SizedBox(width: 8.0),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18.0,
                color: AppColors.violet100,
              )
            ],
          ),
        ],
      ),
    );
  }
}
