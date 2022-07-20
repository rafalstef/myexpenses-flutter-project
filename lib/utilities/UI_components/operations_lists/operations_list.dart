import 'package:flutter/material.dart';
import 'package:myexpenses/enums/user_transaction_enum.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/utilities/UI_components/tiles/operation_tile.dart';
import 'package:myexpenses/views/create_update_operation/create_update_operation.dart';

abstract class OperationsList extends StatelessWidget {
  const OperationsList({Key? key}) : super(key: key);

  Widget getOperationTile(Operation element, BuildContext context) {
    return OperationTile(
      operation: element,
      onTap: (operation) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => CreateUpdateOperation(
              operation: operation,
              userTransaction: (element.category.isIncome == true)
                  ? UserTransaction.income
                  : UserTransaction.expense,
            ),
          ),
        );
      },
    );
  }
}
