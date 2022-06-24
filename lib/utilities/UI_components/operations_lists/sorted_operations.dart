import 'package:flutter/material.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/utilities/UI_components/operations_lists/operations_list.dart';

class SortedOperations extends OperationsList {
  final List<Operation> operations;

  const SortedOperations({
    Key? key,
    required this.operations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40.0),
      itemCount: operations.length,
      itemBuilder: (context, index) {
        final expense = operations.elementAt(index);
        return getOperationTile(expense, context);
      },
    );
  }
}
