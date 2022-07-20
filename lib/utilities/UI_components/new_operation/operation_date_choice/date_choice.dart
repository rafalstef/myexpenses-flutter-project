import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/decorations/app_decorations.dart';
import 'package:myexpenses/utilities/UI_components/new_operation/operation_date_choice/date_option.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/one_choice_filter/option_choice_chips.dart';
import 'package:myexpenses/utilities/formats/date_formats.dart';

class DateChoice extends StatefulWidget {
  final DateTime date;
  final Color iconColor;
  final ValueChanged<DateTime> onChanged;

  const DateChoice({
    Key? key,
    required this.date,
    required this.iconColor,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DateChoice> createState() => _DateChoiceState();
}

class _DateChoiceState extends State<DateChoice> {
  late final DateOption today;
  late final DateOption yesterday;
  late final DateOption other;

  late DateOption selectedDateOption;
  late DateOption previousDateOption;

  late DateTime operationDate;

  @override
  void initState() {
    operationDate = widget.date;
    _initDateOptions();
    _setDateOption();
    super.initState();
  }

  void _initDateOptions() {
    today = DateOption(
      id: 0,
      name: 'Today',
      onTap: () => {
        operationDate = AppDateFormat.today,
        widget.onChanged(operationDate),
      },
    );
    yesterday = DateOption(
      id: 1,
      name: 'Yesterday',
      onTap: () => {
        operationDate = AppDateFormat.yesterday,
        widget.onChanged(operationDate),
      },
    );
    other = DateOption(
      id: 3,
      name: 'Other',
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: operationDate,
          firstDate: DateTime(DateTime.now().year - 1),
          lastDate: AppDateFormat.today,
        );
        if (picked != null) {
          setState(() {
            operationDate = picked;
            widget.onChanged(operationDate);
          });
        } else {
          setState(() {
            selectedDateOption = previousDateOption;
          });
        }
      },
    );
  }

  void _setDateOption() {
    selectedDateOption = (widget.date == AppDateFormat.today)
        ? today
        : (widget.date == AppDateFormat.yesterday)
            ? yesterday
            : other;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.button.roundedBorder(),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.date_range_rounded, color: widget.iconColor),
            const SizedBox(width: 16.0),
            OptionChoiceChips(
              selectedOptionId: selectedDateOption.id,
              onOptionTap: (value) => setState(() {
                previousDateOption = selectedDateOption;
                selectedDateOption = value;
                selectedDateOption.onTap();
              }),
              options: [today, yesterday, other],
            ),
          ],
        ),
      ),
    );
  }
}
