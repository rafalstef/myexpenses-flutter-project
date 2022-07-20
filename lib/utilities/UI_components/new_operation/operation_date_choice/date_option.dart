import 'package:flutter/cupertino.dart';

class DateOption {
  final int id;
  final String name;
  final VoidCallback onTap;

  DateOption({
    required this.id,
    required this.name,
    required this.onTap,
  });
}
