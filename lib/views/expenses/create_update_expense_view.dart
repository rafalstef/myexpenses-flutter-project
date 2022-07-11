import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/category/firebase_category.dart';
import 'package:myexpenses/services/cloud/operation/firebase_operation.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/utilities/formats/date_formats.dart';
import 'package:myexpenses/extensions/build_context_extensions.dart';
import 'package:myexpenses/utilities/dialogs/show_delete_dialog.dart';
import '../numpad.dart';
import 'moneyFormatter.dart';

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
    _categoryService = FirebaseCategory(userUid: userId);
    _accountService = FirebaseAccount(userUid: userId);
    _expenseService = FirebaseOperation(userUid: userId);
    _costController = MoneyMaskedTextController(
        initialValue: 0.0,
        decimalSeparator: '.',
        precision: 2,
        thousandSeparator: '');
    _selectedDate = DateTime.now();
    super.initState();
    _initFirebaseData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _setButtonState(context);
      setState(() {});
    });
  }

  Future<void> _initFirebaseData() async {
    _allCategories = await _categoryService.getCategories();
    _allAccounts = await _accountService.getAccounts();
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
      final double accountAmount = await FirebaseAccount(userUid: userId)
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

  var isVisibleNumpad = true;
  var isVisibleNumpadButton = false;
  var isVisibleDetails = false;

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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(
                        left: 40,
                        top: 40,
                        right: 40,
                        bottom: 0,
                      ),
                      child: Text(
                        'Amount (PLN)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Aleo',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.green),
                      )),
                  Visibility(
                      visible: isVisibleNumpadButton,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: SizedBox(
                          height: 40,
                          child: Center(
                              child: TextField(
                            controller: _costController,
                            textAlign: TextAlign.center,
                            showCursor: false,
                            style: const TextStyle(fontSize: 40),
                            keyboardType: TextInputType.none,
                          )),
                        ),
                      )),
                  Visibility(
                      visible: isVisibleNumpad,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 20),
                        child: SizedBox(
                          height: 40,
                          child: Center(
                              child: TextField(
                            controller: _costController,
                            textAlign: TextAlign.center,
                            showCursor: false,
                            style: const TextStyle(fontSize: 40),
                            keyboardType: TextInputType.none,
                          )),
                        ),
                      )),
                  Visibility(
                      visible: isVisibleNumpad,
                      child: NumPad(
                          buttonSize: 90,
                          buttonColor: AppColors.light100,
                          iconColor: const Color.fromARGB(255, 233, 77, 66),
                          controller: _costController,
                          delete: () {
                            _costController.text = _costController.text
                                .substring(0, _costController.text.length - 1);
                          },
                          onSubmit: () {
                            setState(() {
                              isVisibleNumpad = !isVisibleNumpad;
                              isVisibleNumpadButton = !isVisibleNumpadButton;
                            });
                          })),
                  Visibility(
                    visible: isVisibleNumpadButton,
                    child: ListTile(
                      title: const Text('Change amount'),
                      trailing: const Icon(
                        Icons.attach_money_outlined,
                        color: AppColors.light100,
                      ),
                      onTap: () {
                        setState(() {
                          isVisibleNumpad = !isVisibleNumpad;
                          isVisibleNumpadButton = !isVisibleNumpadButton;
                        });
                      },
                      textColor: AppColors.light100,
                      tileColor: const Color(0xFF023e8a),
                    ),
                  ),
                  Visibility(
                      visible: isVisibleNumpadButton,
                      child: Container(
                        color: const Color(0xFF0077b6),
                        child: ListTile(
                          title: Text(
                            yearMonthDayDash(_selectedDate) ==
                                    yearMonthDayDash(DateTime.now())
                                ? 'TODAY'
                                : yearMonthDayDash(_selectedDate),
                            style: const TextStyle(color: AppColors.light100),
                          ),
                          trailing: const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.light100,
                          ),
                          onTap: () {
                            _selectDateDialog(context);
                          },
                        ),
                      )),
                  Visibility(
                      visible: isVisibleNumpadButton,
                      child: Container(
                        color: const Color(0xFF0096c7),
                        child: ListTile(
                          title: Text(
                            _category == null ? 'Category' : _category!.name,
                            style: const TextStyle(color: AppColors.light100),
                          ),
                          trailing: const Icon(
                            Icons.category,
                            color: AppColors.light100,
                          ),
                          onTap: () {
                            _selectCategoryDialog(context);
                          },
                        ),
                      )),
                  Visibility(
                      visible: isVisibleNumpadButton,
                      child: Container(
                        color: const Color(0xFF00b4d8),
                        child: ListTile(
                          title: Text(
                            _account == null ? 'Account' : _account!.name,
                            style: const TextStyle(color: AppColors.light100),
                          ),
                          trailing: const Icon(
                            Icons.account_balance_outlined,
                            color: AppColors.light100,
                          ),
                          onTap: () {
                            _selectAccountDialog(context);
                          },
                        ),
                      )),
                  Visibility(
                    visible: isVisibleNumpadButton,
                    child: ListTile(
                      title: const Center(
                        child: Icon(
                          Icons.done_rounded,
                          color: AppColors.light100,
                        ),
                      ),
                      onTap: () async {
                        await _saveExpense();
                      },
                      textColor: AppColors.dark100,
                      tileColor: const Color(0xFF48cae4),
                    ),
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
