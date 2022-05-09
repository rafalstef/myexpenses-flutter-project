import 'package:flutter/material.dart';

class ChoiceGroup extends StatelessWidget {
  const ChoiceGroup({
    required this.title,
    required this.options,
    required this.selectedOptionId,
    required this.onOptionTap,
    Key? key,
  }) : super(key: key);

  final String title;
  final List<ChoiceOption> options;
  final dynamic selectedOptionId;
  final ValueChanged<ChoiceOption> onOptionTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sort),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            _OptionList(
              options: options,
              selectedOptionId: selectedOptionId,
              onOptionTap: onOptionTap,
            ),
          ],
        ),
      );
}

class _OptionList extends StatelessWidget {
  const _OptionList({
    required this.selectedOptionId,
    required this.onOptionTap,
    required this.options,
    Key? key,
  }) : super(key: key);

  final List<ChoiceOption> options;
  final dynamic selectedOptionId;
  final ValueChanged<ChoiceOption> onOptionTap;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 10,
        children: [
          ...options.map(
            (option) {
              final isItemSelected = selectedOptionId == option.id;
              return ChoiceChip(
                label: Text(
                  option.name,
                  style: TextStyle(
                    color: isItemSelected ? Colors.white : Colors.black,
                  ),
                ),
                onSelected: (_) => onOptionTap(option),
                selected: isItemSelected,
                backgroundColor: Colors.white,
                selectedColor: Colors.green,
              );
            },
          ).toList(),
        ],
      );
}

class ChoiceOption {
  ChoiceOption({
    required this.id,
    required this.name,
  });
  final dynamic id;
  final String name;
}
