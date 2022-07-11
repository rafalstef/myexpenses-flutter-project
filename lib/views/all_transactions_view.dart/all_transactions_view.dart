import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/enums/sort_method.dart';
import 'package:myexpenses/enums/user_transaction_enum.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import 'package:myexpenses/services/cloud/operation/firebase_operation.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/utilities/UI_components/buttons/pills.dart';
import 'package:myexpenses/utilities/formats/date_formats.dart';
import 'package:myexpenses/utilities/loading_widgets/loading_widget.dart';
import 'package:myexpenses/views/list_preferences/list_preferences.dart';
import 'package:myexpenses/views/all_transactions_view.dart/all_transactions_widgets.dart';
import 'package:myexpenses/views/list_preferences/list_preferences_view.dart';

class AllTransactionsView extends StatefulWidget {
  const AllTransactionsView({Key? key}) : super(key: key);

  @override
  State<AllTransactionsView> createState() => _AllTransactionsViewState();
}

class _AllTransactionsViewState extends State<AllTransactionsView> {
  late final FirebaseOperation _operationService;
  late final FirebaseAccount _accountService;

  late final Future? fetchAllAccounts = _fetchAccounts();
  late Iterable<Account> allAccounts;

  ListPreferences? _listPreferences;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _operationService = FirebaseOperation(userUid: userId);
    _accountService = FirebaseAccount(userUid: userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: NestedScrollView(
        body: _transactionsData(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) =>
            [_buildAppBar()],
      ),
      backgroundColor: AppColors.light100,
    );
  }

  FutureBuilder _transactionsData() {
    return FutureBuilder(
      future: fetchAllAccounts,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (_listPreferences == null) {
              _initListPreferences();
            }
            return StreamBuilder(
              stream: _operationService.preferredOperations(
                preferences: _listPreferences!,
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      Iterable<Operation> allOperations =
                          (snapshot.data != null)
                              ? snapshot.data as Iterable<Operation>
                              : const Iterable.empty();
                      return AllTransactionsWidgets(
                        operations: allOperations,
                        accounts: allAccounts,
                        preferences: _listPreferences!,
                      );
                    } else {
                      return loadingWidget();
                    }
                  default:
                    return loadingWidget();
                }
              },
            );
          default:
            return loadingWidget();
        }
      },
    );
  }

  Future? _fetchAccounts() async {
    allAccounts = await _accountService.getAccounts();
  }

  void _initListPreferences() {
    List<String> accountsId = allAccounts.map((e) => e.documentId).toList();
    _listPreferences = ListPreferences(
      userTransactions: [UserTransaction.expense, UserTransaction.income],
      sortMethod: SortMethod.newest,
      startDate: currentMonthFirstDay,
      endDate: currentMonthLastDay,
      filteredAccountIds: accountsId,
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      centerTitle: true,
      backgroundColor: AppColors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.tune, color: AppColors.dark100),
          onPressed: () => _pushListPreferencesScreen(context),
        )
      ],
      title: Row(
        children: [
          SecondaryPill(
              text: monthName(_listPreferences?.startDate ?? DateTime.now()),
              onPressed: () => _selectMonthDialog(context)),
        ],
      ),
    );
  }

  Future<void> _selectMonthDialog(BuildContext context) async {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month),
      initialDate: _listPreferences!.startDate,
    ).then((date) {
      if (date != null) {
        final newPreferences = ListPreferences(
          userTransactions: _listPreferences!.userTransactions,
          sortMethod: _listPreferences!.sortMethod,
          startDate: date,
          endDate: lastDayOfMonth(date),
          filteredAccountIds: _listPreferences!.filteredAccountIds,
        );
        setState(() {
          _listPreferences = newPreferences;
        });
      }
    });
  }

  Future<void> _pushListPreferencesScreen(BuildContext context) async {
    final newPreferences = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ListPreferencesView(
          preferences: _listPreferences,
          allAccounts: allAccounts,
        );
      },
    );
    if (newPreferences != null) {
      setState(() => _listPreferences = newPreferences);
    }
  }
}
