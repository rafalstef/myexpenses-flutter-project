import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/category/firebase_category.dart';
import 'package:myexpenses/services/cloud/operation/firebase_operation.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/utilities/generics/get_arguments.dart';
import 'package:myexpenses/utilities/show_delete_dialog.dart';

import '../numpad.dart';

class CreateUpdateExpenseView extends StatefulWidget {
  const CreateUpdateExpenseView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateExpenseView> createState() =>
      _CreateUpdateExpenseViewState();
}

class _CreateUpdateExpenseViewState extends State<CreateUpdateExpenseView> {
  Operation? _expense;
  OperationCategory? _category;
  Account? _account;
  late DateTime _selectedDate;

  late final FirebaseOperation _expenseService;
  late final TextEditingController _costController;

  late final FirebaseCategory _categoryService;
  late final Iterable<OperationCategory> _allCategories;

  late final FirebaseAccount _accountService;
  late final Iterable<Account> _allAccounts;

  late final bool isDeleteButtonEnabled;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _categoryService = FirebaseCategory();
    _accountService = FirebaseAccount();
    _expenseService = FirebaseOperation();
    _costController = TextEditingController();
    _selectedDate = DateTime.now();
    super.initState();
    _initFirebaseData();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await _setButtonState(context);
      setState(() {});
    });
  }

  Future<void> _initFirebaseData() async {
    _allCategories = await _categoryService.getCategories(ownerUserId: userId);
    _allAccounts = await _accountService.getAccounts(ownerUserId: userId);
  }

  @override
  void dispose() {
    _costController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async {
    final double cost = double.parse(_costController.text);
    if (cost <= 0 || _category == null || _account == null) {
      return;
    }

    if (_expense == null) {
      final currentUser = AuthService.firebase().currentUser;
      final userId = currentUser!.id;
      final newExpense =
          await _expenseService.createNewOperation(ownerUserId: userId);
      _expense = newExpense;
    }

    await _expenseService.updateOperation(
      documentId: _expense!.documentId,
      category: _category!,
      account: _account!,
      cost: cost,
      date: _selectedDate,
    );

    final double newAmmount = (_category!.isIncome)
        ? _account!.amount + cost
        : _account!.amount - cost;

    await _accountService.updateAccountAmmount(
      documentId: _account!.documentId,
      amount: newAmmount,
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      summaryViewRoute,
      (_) => false,
    );
  }

  Future<Operation?> getExistingExpense(BuildContext context) async {
    final widgetExpense = context.getArgument<Operation>();

    if (widgetExpense == null) {
      return null;
    }

    _expense = widgetExpense;
    _costController.text = widgetExpense.cost.toString();
    _category = widgetExpense.category;
    _account = widgetExpense.account;
    _selectedDate = widgetExpense.date;

    return widgetExpense;
  }

  _selectCategoryDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Category'),
            content: SizedBox(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _allCategories.length,
                itemBuilder: (BuildContext context, int index) {
                  final category = _allCategories.elementAt(index);
                  return ListTile(
                    title: Text(category.name),
                    onTap: () {
                      setState(() {
                        _category = category;
                      });
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  _selectAccountDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Account'),
            content: SizedBox(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _allAccounts.length,
                itemBuilder: (BuildContext context, int index) {
                  final account = _allAccounts.elementAt(index);
                  return ListTile(
                    title: Text(account.name),
                    onTap: () {
                      setState(() {
                        _account = account;
                      });
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  _selectDateDialog(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2001),
      lastDate: DateTime(2023),
    ).then((value) {
      setState(() {
        _selectedDate = value!;
      });
    });
  }

  Future<void> _setButtonState(BuildContext context) async {
    final expense = context.getArgument<Operation>();
    isDeleteButtonEnabled = (expense == null) ? false : true;
  }

  _deleteExpense() async {
    final shouldDelete = await showDeleteDialog(context);
    if (shouldDelete) {
      // get current value of money in account
      final double accountAmount = await FirebaseAccount()
          .getAccountAmount(documentId: _expense!.account!.documentId);
      final double newAmmount = (_category!.isIncome)
          ? accountAmount - _expense!.cost
          : accountAmount + _expense!.cost;

      // update account
      await _accountService.updateAccountAmmount(
        documentId: _account!.documentId,
        amount: newAmmount,
      );

      // delete expense
      await _expenseService.deleteOperation(documentId: _expense!.documentId);
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      summaryViewRoute,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Operation'),
        actions: [
          isDeleteButtonEnabled
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _deleteExpense();
                  },
                )
              : Container(),
        ],
      ),
      body: FutureBuilder(
        future: getExistingExpense(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      height: 70,
                      child: Center(
                          child: TextField(
                        controller: _costController,
                        textAlign: TextAlign.center,
                        showCursor: false,
                        style: const TextStyle(fontSize: 40),
                        // Disable the default soft keybaord
                        keyboardType: TextInputType.none,
                      )),
                    ),
                  ),
                  // implement the custom NumPad
                  NumPad(
                    buttonSize: 75,
                    buttonColor: Colors.blue,
                    iconColor: Colors.green,
                    controller: _costController,
                    delete: () {
                      _costController.text = _costController.text
                          .substring(0, _costController.text.length - 1);
                    },
                    // do something with the input numbers
                    onSubmit: () {},
                  ),
                  TextButton(
                    onPressed: () {
                      _selectDateDialog(context);
                    },
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(_selectedDate).toString(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _selectCategoryDialog(context);
                    },
                    child: Text(_category == null
                        ? 'Choose Category'
                        : _category!.name),
                  ),
                  TextButton(
                    onPressed: () {
                      _selectAccountDialog(context);
                    },
                    child: Text(
                        _account == null ? 'Choose Account' : _account!.name),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _saveExpense();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
