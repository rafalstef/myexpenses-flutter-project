import 'package:flutter/cupertino.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/utilities/UI_components/tiles/operation_tile.dart';

abstract class OperationsList extends StatelessWidget {
  const OperationsList({Key? key}) : super(key: key);

  Widget getOperationTile(Operation element, BuildContext context) {
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
}
