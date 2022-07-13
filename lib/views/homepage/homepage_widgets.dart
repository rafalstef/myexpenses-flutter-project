import 'package:flutter/material.dart';
import 'package:myexpenses/utilities/UI_components/bars/title_with_button_bar.dart';
import 'package:myexpenses/utilities/UI_components/no_operations_widget.dart/no_operation_widget.dart';
import 'package:myexpenses/utilities/UI_components/operations_lists/sorted_operations.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/views/homepage/homepage_top_cards.dart';

class HomePageWidgets extends StatelessWidget {
  final Iterable<Operation> operations;

  const HomePageWidgets({
    Key? key,
    required this.operations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<double> summary = _getFinancialSummary();
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          HomePageTopCards(
            balance: summary[0],
            income: summary[1],
            expense: summary[2],
          ),
          TitleWithButtonBar(
            title: 'Recent Transaction',
            buttonTitle: 'See All',
            onPressed: () {},
          ),
          _recentTransaction(context),
        ],
      ),
    );
  }

  Widget _recentTransaction(BuildContext context) => (operations.isEmpty)
      ? const NoOperations()
      : SortedOperations(operations: operations.toList());

  List<double> _getFinancialSummary() {
    // summary = [balance, incomes, expenses]
    List<double> summary = List.filled(3, 0, growable: false);
    for (final operation in operations) {
      operation.category.isIncome
          ? summary[1] += operation.cost
          : summary[2] += operation.cost;
    }
    summary[0] = summary[1] - summary[2];
    return summary;
  }
}
