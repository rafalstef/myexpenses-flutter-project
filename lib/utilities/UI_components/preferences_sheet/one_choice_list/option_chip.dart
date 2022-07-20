import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';

class OptionChip extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;

  const OptionChip({
    Key? key,
    required this.name,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 16, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(
              icon,
              color: AppColors.light100,
              size: 14.0,
            ),
            radius: 14.0,
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              name,
              style: AppTextStyles.regularMedium(AppColors.dark60),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        border: Border.all(color: AppColors.light20, width: 1.0),
      ),
    );
  }
}
