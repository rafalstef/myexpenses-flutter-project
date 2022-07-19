import 'package:flutter/material.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/list_filter.dart/filter_list_option.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/one_choice_list/one_choice_list_group.dart';

class ItemChoiceGroup extends StatelessWidget {
  final String listTitle;
  final Widget icon;
  final List<dynamic> items;
  final dynamic selectedItem;
  final ValueChanged<String> onOptionTap;

  const ItemChoiceGroup({
    required this.listTitle,
    required this.icon,
    required this.items,
    required this.selectedItem,
    required this.onOptionTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OneChoiceListGroup(
      text: listTitle,
      icon: icon,
      options: items
          .map(
            (item) => FilterListOption(
              id: item.documentId,
              name: item.name,
              icon: item.icon,
              color: item.color,
            ),
          )
          .toList(),
      selectedOption: selectedItem.documentId,
      onOptionTap: onOptionTap,
    );
  }
}
