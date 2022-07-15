import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/utilities/UI_components/buttons/large_buttons.dart';

class ListTileSelect extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final ButtonCallback onTap;

  const ListTileSelect({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: widget.color,
            radius: 18,
            child: Icon(
              widget.icon,
              color: AppColors.light100,
            ),
          ),
          const SizedBox(width: 16.0),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              widget.title,
              style: AppTextStyles.regularMedium(AppColors.dark100),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      checkboxShape: const CircleBorder(),
      checkColor: AppColors.light100,
      activeColor: AppColors.violet100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    );
  }
}
