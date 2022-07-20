import 'package:flutter/material.dart';
import 'package:myexpenses/enums/user_transaction_enum.dart';
import 'package:myexpenses/extensions/string_extensions.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/category/firebase_category.dart';
import 'package:myexpenses/services/cloud/operation/firebase_operation.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/utilities/UI_components/app_bars/custom_app_bars.dart';
import 'package:myexpenses/utilities/UI_components/loading_widgets/loading_widget.dart';
import 'package:myexpenses/views/create_update_operation/create_update_operation_view.dart';

class CreateUpdateOperation extends StatefulWidget {
  final Operation? operation;
  final UserTransaction userTransaction;

  const CreateUpdateOperation({
    Key? key,
    required this.operation,
    required this.userTransaction,
  }) : super(key: key);

  @override
  State<CreateUpdateOperation> createState() => _CreateUpdateOperationState();
}

class _CreateUpdateOperationState extends State<CreateUpdateOperation> {
  late final FirebaseOperation _expenseService;
  Operation? get operation => widget.operation;

  late final FirebaseCategory _categoryService;
  late final Iterable<OperationCategory> _categories;

  late final FirebaseAccount _accountService;
  late final Iterable<Account> _accounts;

  String get userId => AuthService.firebase().currentUser!.id;
  late final Future<void> futureData = _initData(context);

  @override
  void initState() {
    _categoryService = FirebaseCategory(userUid: userId);
    _accountService = FirebaseAccount(userUid: userId);
    _expenseService = FirebaseOperation(userUid: userId);
    super.initState();
  }

  Future<void> _initData(BuildContext context) async {
    _accounts = await _accountService.getAccounts();
    _categories = await _categoryService.oneTypeCategories(
      type: widget.userTransaction == UserTransaction.expense
          ? UserTransaction.expense
          : UserTransaction.income,
    );
  }

  Future<void> _saveExpense({
    required double cost,
    required String description,
    required OperationCategory category,
    required Account account,
    required DateTime date,
  }) async {
    if (operation == null) {
      // create new Operation
      await _expenseService.createNewOperation(
        cost: cost,
        date: date,
        description: description,
        account: account,
        category: category,
      );
    } else {
      // update existing Operation
      await _expenseService.updateOperation(
        documentId: operation!.documentId,
        cost: cost,
        date: date,
        description: description,
        account: account,
        category: category,
      );
    }

    // update account
    final double newAmmount =
        (category.isIncome) ? account.amount + cost : account.amount - cost;

    await _accountService.updateAccountAmmount(
      documentId: account.documentId,
      amount: newAmmount,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.transparent(
          textColor: AppColors.light100,
          title: widget.userTransaction.name.capitalize()),
      backgroundColor: widget.userTransaction == UserTransaction.expense
          ? AppColors.red100
          : AppColors.green100,
      body: FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return CreateUpdateOperationView(
                operation: operation,
                userTransaction: UserTransaction.expense,
                accounts: _accounts.toList(),
                categories: _categories.toList(),
                onTapSaveButton: _saveExpense,
              );
            case ConnectionState.none:
              return loadingWidget();
            case ConnectionState.waiting:
              return loadingWidget();
            case ConnectionState.active:
              return loadingWidget();
          }
        },
      ),
    );
  }
}
