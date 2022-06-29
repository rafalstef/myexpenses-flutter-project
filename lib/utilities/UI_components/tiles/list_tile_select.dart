import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/UI_components/buttons/large_buttons.dart';

class ListTileSelect extends StatefulWidget {
  final String title;
  final bool isSelected;
  final ButtonCallback onTap;

  const ListTileSelect({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ListTileSelect> createState() => _ListTileSelectState();
}

class _ListTileSelectState extends State<ListTileSelect> {
  bool? _isSelected;

  @override
  void initState() {
    _isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: _isSelected,
      onChanged: (value) {
        setState(() {
          _isSelected = value;
          widget.onTap();
        });
      },
      title: Text(
        widget.title,
        style: AppTextStyles.smallMedium(AppColors.dark100),
      ),
      checkboxShape: const CircleBorder(),
      checkColor: AppColors.light100,
      activeColor: AppColors.violet100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    );
  }
}
