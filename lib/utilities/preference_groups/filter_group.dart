import 'package:flutter/material.dart';

class FilterGroup extends StatelessWidget {
  const FilterGroup({
    required this.title,
    required this.options,
    required this.onOptionTap,
    Key? key,
  }) : super(key: key);
  final String title;
  final List<FilterOption> options;
  final ValueChanged<FilterOption> onOptionTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.filter_list),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            _OptionList(
              options: options,
              onOptionTap: onOptionTap,
            ),
          ],
        ),
      );
}

class _OptionList extends StatelessWidget {
  const _OptionList({
    required this.options,
    required this.onOptionTap,
    Key? key,
  }) : super(key: key);
  final List<FilterOption> options;
  final ValueChanged<FilterOption> onOptionTap;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 10,
        children: [
          ...options
              .map(
                (option) => FilterChip(
                  label: Text(
                    option.name,
                    style: TextStyle(
                      color: option.isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  onSelected: (_) => onOptionTap(option),
                  selected: option.isSelected,
                  backgroundColor: Colors.white,
                  selectedColor: Colors.green,
                  checkmarkColor: Colors.white,
                ),
              )
              .toList(),
        ],
      );
}

class FilterOption {
  FilterOption({
    required this.id,
    required this.name,
    required this.isSelected,
  });
  final dynamic id;
  final String name;
  final bool isSelected;
}
