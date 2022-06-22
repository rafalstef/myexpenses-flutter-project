import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';

class AppNavigationBar extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangedTab;

  const AppNavigationBar({
    Key? key,
    required this.index,
    required this.onChangedTab,
  }) : super(key: key);

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  @override
  Widget build(BuildContext context) {
    const placeHolder = Opacity(
      opacity: 0,
      child: IconButton(icon: Icon(Icons.abc), onPressed: null),
    );

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: AppColors.light80,
      elevation: 0,
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _bottomAppBarItem(icon: const Icon(Icons.home_rounded), index: 0),
            _bottomAppBarItem(
                icon: const Icon(Icons.compare_arrows_rounded), index: 1),
            placeHolder,
            _bottomAppBarItem(
                icon: const Icon(Icons.pie_chart_rounded), index: 2),
            _bottomAppBarItem(
                icon: const Icon(Icons.more_horiz_rounded), index: 3),
          ],
        ),
      ),
    );
  }

  Widget _bottomAppBarItem({
    required int index,
    required Icon icon,
  }) {
    final isSelected = index == widget.index;

    return IconTheme(
      data: IconThemeData(
        size: 28.0,
        color: isSelected ? AppColors.violet100 : AppColors.dark20,
      ),
      child: IconButton(
        onPressed: () => widget.onChangedTab(index),
        icon: icon,
      ),
    );
  }
}
