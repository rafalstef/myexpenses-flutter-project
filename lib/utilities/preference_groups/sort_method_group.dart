import 'package:flutter/material.dart';
import 'package:myexpenses/enums/sort_method.dart';
import 'package:myexpenses/utilities/preference_groups/choice_group.dart';

class SortMethodGroup extends StatelessWidget {
  const SortMethodGroup({
    required this.selectedItem,
    required this.onOptionTap,
    Key? key,
  }) : super(key: key);

  final ValueChanged<ChoiceOption> onOptionTap;
  final SortMethod selectedItem;
  @override
  Widget build(BuildContext context) => ChoiceGroup(
        title: 'Sort by',
        options: SortMethod.values
            .map((sortMethod) => ChoiceOption(
                  id: sortMethod,
                  name: sortMethod == SortMethod.newest
                      ? 'Newest'
                      : sortMethod == SortMethod.oldest
                          ? 'Oldest'
                          : sortMethod == SortMethod.biggest
                              ? 'Highest'
                              : 'Lowest',
                ))
            .toList(),
        selectedOptionId: selectedItem,
        onOptionTap: onOptionTap,
      );
}
