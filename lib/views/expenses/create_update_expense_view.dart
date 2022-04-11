import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/category/firebase_category.dart';
import 'package:myexpenses/services/cloud/expense/expense.dart';
import 'package:myexpenses/services/cloud/expense/firebase_expense.dart';
import 'package:myexpenses/utilities/generics/get_arguments.dart';

class CreateUpdateExpenseView extends StatefulWidget {
  const CreateUpdateExpenseView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateExpenseView> createState() =>
      _CreateUpdateExpenseViewState();
}

class _CreateUpdateExpenseViewState extends State<CreateUpdateExpenseView> {
  Expense? _expense;
  ExpenseCategory? _category;
  Account? _account;
  late DateTime _selectedDate;

  late final FirebaseExpense _expenseService;
  late final TextEditingController _costController;

  late final FirebaseCategory _categoryService;
  late final Iterable<ExpenseCategory> _allCategories;

  late final FirebaseAccount _accountService;
  late final Iterable<Account> _allAccounts;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _categoryService = FirebaseCategory();
    _accountService = FirebaseAccount();
    _expenseService = FirebaseExpense();
    _costController = TextEditingController();
    _selectedDate = DateTime.now();
    super.initState();
    _initFirebaseData();
  }

  Future<void> _initFirebaseData() async {
    _allCategories = await _categoryService.getCategories(ownerUserId: userId);
    _allAccounts = await _accountService.getAccounts(owenrUserId: userId);
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
          await _expenseService.createNewExpense(ownerUserId: userId);
      _expense = newExpense;
    }

    await _expenseService.updateExpense(
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

  Future<Expense?> getExistingExpense(BuildContext context) async {
    final widgetExpense = context.getArgument<Expense>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Expense'),
      ),
      body: FutureBuilder(
        future: getExistingExpense(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _costController,
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Cost',
                    ),
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
