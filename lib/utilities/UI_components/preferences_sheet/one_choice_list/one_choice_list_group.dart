import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/decorations/app_decorations.dart';
import 'package:myexpenses/utilities/UI_components/icons_containers/option_chip.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/list_filter.dart/filter_list_option.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/one_choice_list/one_choice_options_list.dart';

class OneChoiceListGroup extends StatelessWidget {
  final String text;
  final Widget icon;
  final List<FilterListOption> options;
  final String selectedOption;
  final ValueChanged<String> onOptionTap;

  const OneChoiceListGroup({
    required this.text,
    required this.icon,
    required this.options,
    required this.selectedOption,
    required this.onOptionTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        onOptionTap(
          await _selectOptionsFromList(
            context: context,
            options: options,
            selectedOption: selectedOption,
          ),
        );
      },
      child: _buildButton(
        context: context,
        icon: icon,
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required Widget icon,
  }) {
    final dynamic option =
        options.firstWhere((element) => element.id == selectedOption);
    return Container(
      decoration: AppDecorations.button.roundedBorder(),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                icon,
                const SizedBox(width: 16.0),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  child: OptionChip(
                    name: option.name,
                    icon: option.icon,
                    color: option.color,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 36.0,
              color: AppColors.dark20,
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _selectOptionsFromList({
    required BuildContext context,
    required List<FilterListOption> options,
    required String selectedOption,
  }) async =>
      await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return OneChoiceOptionsList(
            listTitle: text,
            options: options,
            selected: selectedOption,
          );
        },
      );
}
