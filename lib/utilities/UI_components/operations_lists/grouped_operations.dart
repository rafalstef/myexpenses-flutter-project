import 'package:flutter/cupertino.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:myexpenses/enums/sort_method.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/utilities/UI_components/bars/grouped_operations_label.dart';
import 'package:myexpenses/utilities/UI_components/operations_lists/operations_list.dart';
import 'package:myexpenses/utilities/formats/date_formats.dart';

class GroupedOperations extends OperationsList {
  final List<Operation> operations;
  final SortMethod sortMethod;

  const GroupedOperations({
    Key? key,
    required this.operations,
    required this.sortMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GroupedListView<dynamic, String>(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40),
      elements: operations,
      groupBy: (element) => AppDateFormat.yearMonthDayDash(element.date),
      groupSeparatorBuilder: (String groupByValue) {
        return GroupedOperationsLabelBar(label: groupByValue);
      },
      itemComparator: (item1, item2) {
        return (item1.date).compareTo(item2.date);
      },
      order: (sortMethod == SortMethod.newest)
          ? GroupedListOrder.DESC
          : GroupedListOrder.ASC,
      itemBuilder: (context, dynamic element) {
        return getOperationTile(element, context);
      },
    );
  }
}
