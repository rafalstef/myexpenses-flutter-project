import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/decorations/app_decorations.dart';
import 'package:myexpenses/enums/sort_method.dart';
import 'package:myexpenses/enums/user_transaction_enum.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/utilities/UI_components/bars/title_with_button_bar.dart';
import 'package:myexpenses/utilities/UI_components/buttons/large_buttons.dart';
import 'package:myexpenses/utilities/formats/date_formats.dart';
import 'package:myexpenses/views/list_preferences/list_preferences.dart';
import 'package:myexpenses/extensions/list_extensions.dart';
import 'package:myexpenses/views/list_preferences/preference_groups/account_filter_group.dart';
import 'package:myexpenses/views/list_preferences/preference_groups/sort_method_group.dart';
import 'package:myexpenses/views/list_preferences/preference_groups/user_transaction_group.dart';

class ListPreferencesView extends StatefulWidget {
  final ListPreferences? preferences;
  final Iterable<Account> allAccounts;

  const ListPreferencesView({
    Key? key,
    required this.preferences,
    required this.allAccounts,
  }) : super(key: key);

  @override
  _ListPreferencesViewState createState() => _ListPreferencesViewState();
}

class _ListPreferencesViewState extends State<ListPreferencesView> {
  String get userId => AuthService.firebase().currentUser!.id;

  List<UserTransaction> _selectedTransactions = [];

  SortMethod _selectedSortMethod = SortMethod.newest;

  DateTime _selectedStartDate = AppDateFormat.currentMonthFirstDay;
  DateTime _selectedEndDate = AppDateFormat.currentMonthLastDay;

  List<String> _selectedAccountIds = [];

  final List<UserTransaction> _transactions = [
    UserTransaction.expense,
    UserTransaction.income,
  ];

  // get previous settings
  ListPreferences? get _previousPreferences => widget.preferences;

  List<dynamic> get _previousAccountIds =>
      _previousPreferences?.filteredAccountIds ?? [];

  DateTime get _previousStartDate =>
      _previousPreferences?.startDate ?? AppDateFormat.currentMonthFirstDay;

  DateTime get _previousEndDate =>
      _previousPreferences?.endDate ?? AppDateFormat.currentMonthLastDay;

  SortMethod get _previousSortMethod =>
      _previousPreferences?.sortMethod ?? SortMethod.newest;

  List<UserTransaction> get _previousTransactions =>
      _previousPreferences?.userTransactions ?? [];

  // check if any preferences have changed
  bool get _hasChangedUserTransactions =>
      !listEquals(_previousTransactions, _selectedTransactions);

  bool get _hasChangedAccounts =>
      !listEquals(_previousAccountIds, _selectedAccountIds);

  bool get _hasChangedStartDate => _previousStartDate != _selectedStartDate;

  bool get _hasChangedEndDate => _previousEndDate != _selectedEndDate;

  bool get _hasChangedSortMethod => _previousSortMethod != _selectedSortMethod;

  bool get _hasChangedPreferences =>
      _hasChangedUserTransactions ||
      _hasChangedAccounts ||
      _hasChangedStartDate ||
      _hasChangedEndDate ||
      _hasChangedSortMethod;

  @override
  void initState() {
    // initialize preferences
    final previousPreferences = widget.preferences;
    if (previousPreferences != null) {
      _selectedSortMethod = previousPreferences.sortMethod;
      _selectedStartDate = previousPreferences.startDate;
      _selectedEndDate = previousPreferences.endDate;
      _selectedAccountIds = List.of(previousPreferences.filteredAccountIds);
      _selectedTransactions = List.of(previousPreferences.userTransactions);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.bottomSheetDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _decorationLine(),
            TitleWithButtonBar(
              title: 'Filter Transaction',
              buttonTitle: 'Reset',
              onPressed: () => _preferencesReset(),
            ),
            TransactionFilterGroup(
              transactions: _transactions,
              selectedItemsIds: _selectedTransactions,
              onOptionTap: (option) => setState(
                () => _selectedTransactions.toggleItem(option.id),
              ),
            ),
            SortMethodGroup(
              selectedItem: _selectedSortMethod,
              onOptionTap: (option) => setState(
                () => _selectedSortMethod = option.id,
              ),
            ),
            AccountFilterGroup(
              accounts: widget.allAccounts.toList(),
              selectedAccountsIds: _selectedAccountIds,
              onOptionTap: (option) => setState(
                () => _selectedAccountIds = option,
              ),
            ),
            LargePrimaryButton(
              text: 'Apply',
              onPressed: () => _sendResultsBack(context: context),
            )
          ],
        ),
      ),
    );
  }

  void _sendResultsBack({required BuildContext context}) {
    _hasChangedPreferences
        ? Navigator.of(context).pop(
            ListPreferences(
              userTransactions: _selectedTransactions,
              sortMethod: _selectedSortMethod,
              startDate: _selectedStartDate,
              endDate: _selectedEndDate,
              filteredAccountIds: _selectedAccountIds,
            ),
          )
        : Navigator.of(context).pop();
  }

  void _preferencesReset() {
    setState(() {
      _selectedTransactions = [UserTransaction.expense, UserTransaction.income];
      _selectedSortMethod = SortMethod.newest;
      _selectedAccountIds.clear();
      _selectedAccountIds =
          widget.allAccounts.map((e) => e.documentId).toList();
    });
  }
}

Widget _decorationLine() {
  return Column(
    children: [
      const SizedBox(height: 4.0),
      Container(
        height: 6.0,
        width: 48.0,
        decoration: const BoxDecoration(
          color: AppColors.violet40,
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
      ),
    ],
  );
}
