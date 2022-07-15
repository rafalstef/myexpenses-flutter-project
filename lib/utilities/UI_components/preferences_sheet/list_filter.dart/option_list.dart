import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/decorations/app_decorations.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/extensions/list_extensions.dart';
import 'package:myexpenses/utilities/UI_components/buttons/small_buttons.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/list_filter.dart/filter_list_option.dart';
import 'package:myexpenses/utilities/UI_components/tiles/list_tile_select.dart';

class OptionList extends StatelessWidget {
  final String listTitle;
  final List<FilterListOption> options;
  final Iterable<String> selectedOptions;

  const OptionList({
    required this.listTitle,
    required this.options,
    required this.selectedOptions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double _minSheetHeight = 0.3;
    final double _sheetHeight =
        (options.length > 7) ? 0.8 : options.length * 0.07 + _minSheetHeight;

    List<String> _newSelected = selectedOptions.toList();

    return _makeDismissible(
      context: context,
      child: DraggableScrollableSheet(
        initialChildSize: _sheetHeight,
        minChildSize: _minSheetHeight,
        maxChildSize: _sheetHeight,
        builder: (context, controller) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: AppDecorations.bottomSheetDecoration(),
            child: Column(
              children: [
                _buildListTitle(),
                _buildListItems(
                  controller: controller,
                  selectedOptions: _newSelected,
                ),
                _buildListControlButtons(
                  context: context,
                  selectedOptions: _newSelected,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _makeDismissible({
    required BuildContext context,
    required Widget child,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(
        onTap: () {},
        child: child,
      ),
    );
  }

  Widget _buildListTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          listTitle,
          style: AppTextStyles.title3(AppColors.dark100),
        ),
      ),
    );
  }

  Widget _buildListItems({
    required ScrollController controller,
    required List<String> selectedOptions,
  }) {
    const Divider _divider = Divider(color: AppColors.light20, thickness: 1.0);
    return Expanded(
      child: ListView.builder(
        controller: controller,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          return Column(
            children: [
              if (index == 0) _divider,
              ListTileSelect(
                title: option.name,
                icon: option.icon,
                color: option.color,
                isSelected: (selectedOptions.contains(option.id)),
                onTap: () {
                  selectedOptions.toggleItem(option.id);
                },
              ),
              _divider,
            ],
          );
        },
      ),
    );
  }

  Widget _buildListControlButtons({
    required BuildContext context,
    required List<String> selectedOptions,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SmallSecondaryButton(
          text: 'Cancel',
          onPressed: () {
            Navigator.of(context).pop(selectedOptions);
          },
        ),
        SmallPrimaryButton(
          text: 'Done',
          onPressed: () {
            Navigator.of(context).pop(selectedOptions);
          },
        ),
      ],
    );
  }
}
