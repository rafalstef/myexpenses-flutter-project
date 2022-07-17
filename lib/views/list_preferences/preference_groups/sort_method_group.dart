import 'package:flutter/material.dart';
import 'package:myexpenses/enums/sort_method.dart';
import 'package:myexpenses/extensions/string_extensions.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/one_choice_filter/filter_option.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/one_choice_filter/one_choice_filter_group.dart';

class SortMethodGroup extends StatelessWidget {
  const SortMethodGroup({
    required this.selectedItem,
    required this.onOptionTap,
    Key? key,
  }) : super(key: key);

  final SortMethod selectedItem;
  final ValueChanged<dynamic> onOptionTap;
  
  @override
  Widget build(BuildContext context) {
    return OneChoiceFilterGroup(
      title: 'Sort by',
      icon: Icons.sort_rounded,
      options: SortMethod.values
          .map((sortMethod) => FilterOption(
                id: sortMethod,
                name: sortMethod.name.capitalize(),
              ))
          .toList(),
      selectedOptionId: selectedItem,
      onOptionTap: onOptionTap,
    );
  }
}
