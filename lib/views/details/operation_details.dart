import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/decorations/app_decorations.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/enums/user_transaction_enum.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import 'package:myexpenses/services/cloud/operation/firebase_operation.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/utilities/UI_components/app_bars/custom_app_bars.dart';
import 'package:myexpenses/utilities/UI_components/details/details_card.dart';
import 'package:myexpenses/utilities/dialogs/show_delete_dialog.dart';
import 'package:myexpenses/utilities/formats/date_formats.dart';
import 'package:myexpenses/utilities/formats/money_formats.dart';
import 'package:myexpenses/views/create_update_operation/create_update_operation.dart';

class OperationDetails extends StatefulWidget {
  final Operation operation;

  const OperationDetails({
    Key? key,
    required this.operation,
  }) : super(key: key);

  @override
  State<OperationDetails> createState() => _OperationDetailsState();
}

class _OperationDetailsState extends State<OperationDetails> {
  Operation get _operation => widget.operation;
  String get userId => AuthService.firebase().currentUser!.id;
  bool get _isIncome => _operation.category.isIncome;
  Color get _leadingColor =>
      (_isIncome) ? AppColors.green100 : AppColors.red100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.operationDetail(
        color: _leadingColor,
        onTapDelete: _deleteExpense,
      ),
      body: _buildOperationInfo(context),
      floatingActionButton: _editButton(context),
    );
  }

  Container _buildOperationInfo(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.3,
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      width: MediaQuery.of(context).size.width,
      decoration: AppDecorations.operationDetails(color: _leadingColor),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              _operationCost(),
              _operationDescription(),
              _operationDate(),
              const SizedBox(height: 50),
            ],
          ),
          Positioned(
            bottom: -50,
            child: DetailsCard(operation: _operation),
          ),
        ],
      ),
    );
  }

  Text _operationDate() {
    return Text(
      AppDateFormat.yearMonthWeekdayDay(_operation.date),
      style: AppTextStyles.smallMedium(AppColors.light80.withOpacity(0.88)),
    );
  }

  Widget _operationDescription() {
    return (_operation.description == '')
        ? const SizedBox(height: 15.0)
        : Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              child: Text(
                _operation.description,
                textAlign: TextAlign.center,
                style: AppTextStyles.regularSemiBold(AppColors.light80),
                overflow: TextOverflow.fade,
              ),
            ),
          );
  }

  Text _operationCost() {
    return Text(
      moneyFormat(_operation.cost),
      style: const TextStyle(
        color: AppColors.light100,
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  FloatingActionButton _editButton(BuildContext context) {
    return FloatingActionButton.extended(
      label: const Text('Edit'),
      icon: const Icon(Icons.edit),
      elevation: 0,
      backgroundColor: _isIncome ? AppColors.green100 : AppColors.red100,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => CreateUpdateOperation(
              operation: _operation,
              userTransaction: (_isIncome == true)
                  ? UserTransaction.income
                  : UserTransaction.expense,
            ),
          ),
        );
      },
    );
  }

  void _deleteExpense() async {
    final shouldDelete = await showDeleteDialog(context);
    if (shouldDelete) {
      final accountService = FirebaseAccount(userUid: userId);

      final double accountAmount = await accountService.getAccountAmount(
          documentId: _operation.account.documentId);
      final double newAmmount = (_isIncome)
          ? accountAmount - _operation.cost
          : accountAmount + _operation.cost;

      // update account
      await accountService.updateAccountAmmount(
        documentId: _operation.account.documentId,
        amount: newAmmount,
      );

      final operationService = FirebaseOperation(userUid: userId);
      // delete expense
      await operationService.deleteOperation(documentId: _operation.documentId);
    }

    Navigator.pop(context);
  }
}
