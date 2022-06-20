import 'package:flutter/material.dart';

class TileIcon extends StatelessWidget {
  const TileIcon({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.containerColor,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: containerColor,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 28.0,
      ),
    );
  }
}
