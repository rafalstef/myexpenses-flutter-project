import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:myexpenses/utilities/formats/date_formats.dart';

typedef MonthGroupCallback = void Function(
    DateTime startDate, DateTime endDate);

class MonthGroup extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final MonthGroupCallback onOptionTap;

  const MonthGroup({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onOptionTap,
  }) : super(key: key);

  @override
  State<MonthGroup> createState() => _MonthGroupState();
}

class _MonthGroupState extends State<MonthGroup> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  Widget build(BuildContext context) {
    startDate = widget.startDate;
    endDate = widget.endDate;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.date_range),
              const SizedBox(width: 8),
              Text(
                'Adjust the date range',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _selectStartDate(startDate),
          _selectEndDate(endDate),
        ],
      ),
    );
  }

  DateTimePicker _selectStartDate(DateTime initDate) {
    return DateTimePicker(
      type: DateTimePickerType.date,
      initialValue: initDate.toString(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      icon: const Icon(Icons.edit_calendar_outlined),
      dateLabelText: 'Start',
      onChanged: (val) =>
          setState(() => widget.onOptionTap(toDate(val), endDate)),
    );
  }

  DateTimePicker _selectEndDate(DateTime initDate) {
    return DateTimePicker(
      type: DateTimePickerType.date,
      initialValue: initDate.toString(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      icon: const Icon(Icons.edit_calendar_outlined),
      dateLabelText: 'End',
      onChanged: (val) =>
          setState(() => widget.onOptionTap(startDate, toDate(val))),
    );
  }
}
