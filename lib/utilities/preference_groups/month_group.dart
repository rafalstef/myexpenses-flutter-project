import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

typedef MonthGroupCallback = void Function(DateTime month);

class MonthGroup extends StatefulWidget {
  final DateTime selectedDate;
  final MonthGroupCallback onOptionTap;

  const MonthGroup({
    Key? key,
    required this.selectedDate,
    required this.onOptionTap,
  }) : super(key: key);

  @override
  State<MonthGroup> createState() => _MonthGroupState();
}

class _MonthGroupState extends State<MonthGroup> {
  @override
  Widget build(BuildContext context) {
    String dateFormat = DateFormat('yMMMM').format(widget.selectedDate);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.date_range),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Choose Month',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          TextButton(
            onPressed: () {
              _selectMonthDialog(context);
            },
            child: Text(dateFormat),
          )
        ],
      ),
    );
  }

  void _selectMonthDialog(BuildContext context) async {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month),
      initialDate: widget.selectedDate,
    ).then((date) {
      if (date != null) {
        widget.onOptionTap(date);
        setState(() {});
      }
    });
  }
}
