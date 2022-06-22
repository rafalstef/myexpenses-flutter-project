import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/utilities/UI_components/bars/see_all_bar.dart';
import 'package:myexpenses/utilities/formats/date_formats.dart';
import 'package:myexpenses/utilities/formats/money_formats.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/utilities/UI_components/tiles/operation_tile.dart';
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
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          HomePageTopCards(
            balance: summary[0],
            income: summary[1],
            expense: summary[2],
          ),
          const SeeAllBar(),
          _recentTransaction(context),
        ],
      ),
    );
  }

  Widget _recentTransaction(BuildContext context) => (operations.isEmpty)
      ? _noOperationsWidget(context)
      : _groupedOperationsList(operations.toList());

  SizedBox _noOperationsWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Center(
        child: Text(
          _noOperationMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  GroupedListView<dynamic, String> _groupedOperationsList(
      List<Operation> operationList) {
    return GroupedListView<dynamic, String>(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40),
      elements: operationList,
      groupBy: (element) => yearMonthDayDash(element.date),
      groupSeparatorBuilder: (String groupByValue) {
        double sum =
            _calculateGroupedOperationsSum(operationList, groupByValue);
        return _groupedOperationsLabel(groupByValue, sum);
      },
      itemComparator: (item1, item2) {
        return (item1.date).compareTo(item2.date);
      },
      order: GroupedListOrder.DESC,
      itemBuilder: (context, dynamic element) {
        return _getOperationTile(element, context);
      },
    );
  }

  double _calculateGroupedOperationsSum(
      List<Operation> operationList, String groupByValue) {
    double sum = 0;
    for (var element in operationList) {
      if (yearMonthDayDash(element.date) == groupByValue) {
        (element.category!.isIncome)
            ? sum += element.cost
            : sum -= element.cost;
      }
    }
    return sum;
  }

  Widget _groupedOperationsLabel(String groupByValue, double sum) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
      child: Row(
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  weekdayMonthDay(toDate(groupByValue)),
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  moneyFormat(sum),
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<double> _getFinancialSummary() {
    // summary = [balance, incomes, expenses]
    List<double> summary = List.filled(3, 0, growable: false);
    for (final operation in operations) {
      operation.category!.isIncome
          ? summary[1] += operation.cost
          : summary[2] += operation.cost;
    }
    summary[0] = summary[1] - summary[2];
    return summary;
  }

  Widget _getOperationTile(Operation element, BuildContext context) {
    return OperationTile(
      operation: element,
      onTap: (expense) {
        Navigator.of(context).pushNamed(
          createOrUpdateExpenseRoute,
          arguments: expense,
        );
      },
    );
  }

  final String _noOperationMessage =
      'There are no expenses here. Try changing the time span or accounts to find them.';
}
