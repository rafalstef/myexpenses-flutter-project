import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';

class SwitchTabBar extends StatefulWidget {
  final TabController tabController;
  final String first;
  final String second;

  const SwitchTabBar({
    Key? key,
    required this.tabController,
    required this.first,
    required this.second,
  }) : super(key: key);

  @override
  State<SwitchTabBar> createState() => _SwitchTabBarState();
}

class _SwitchTabBarState extends State<SwitchTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        color: AppColors.violet20,
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: TabBar(
        controller: widget.tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0),
          color: AppColors.violet100,
        ),
        unselectedLabelColor: AppColors.dark100,
        labelStyle: AppTextStyles.regularMedium(AppColors.light100),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) => Colors.transparent,
        ),
        tabs: [
          Tab(text: widget.first),
          Tab(text: widget.second),
        ],
      ),
    );
  }
}
