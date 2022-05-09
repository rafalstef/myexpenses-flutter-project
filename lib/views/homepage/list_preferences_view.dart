import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myexpenses/enums/sort_method.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/utilities/preference_groups/account_filter_group.dart';
import 'package:myexpenses/utilities/preference_groups/list_preferences.dart';
import 'package:myexpenses/utilities/preference_groups/month_group.dart';
import 'package:myexpenses/utilities/preference_groups/sort_method_group.dart';

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

  SortMethod _selectedSortMethod = SortMethod.newest;
  DateTime _selectedMonth = DateTime.now();
  List<String> _selectedAccountIds = [];

  // get previous settings
  ListPreferences? get _previousPreferences => widget.preferences;

  List<dynamic> get _previousAccountIds =>
      _previousPreferences?.filteredAccountIds ?? [];

  DateTime get _previousMonth =>
      _previousPreferences?.preferedMonth ?? DateTime.now();

  SortMethod get _previousSortMethod =>
      _previousPreferences?.sortMethod ?? SortMethod.newest;

  // check if any settings have changed
  bool get _hasChangedAccounts => !listEquals(
        _previousAccountIds,
        _selectedAccountIds,
      );

  bool get _hasChangedMonth {
    if (_previousMonth.month != _selectedMonth.month ||
        _previousMonth.year != _selectedMonth.year) {
      return true;
    } else {
      return false;
    }
  }

  bool get _hasChangedSortMethod => _previousSortMethod != _selectedSortMethod;

  bool get _hasChangedPreferences =>
      _hasChangedAccounts || _hasChangedMonth || _hasChangedSortMethod;

  get allAccounts => widget.allAccounts;

  @override
  void initState() {
    final previousPreferences = widget.preferences;
    if (previousPreferences != null) {
      _selectedSortMethod = previousPreferences.sortMethod;
      _selectedMonth = previousPreferences.preferedMonth;
      _selectedAccountIds = List.of(previousPreferences.filteredAccountIds);
    }
    super.initState();
  }

  void _sendResultsBack(BuildContext context) {
    Navigator.of(context).pop(
      ListPreferences(
        sortMethod: _selectedSortMethod,
        preferedMonth: _selectedMonth,
        filteredAccountIds: _selectedAccountIds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'List Preferences',
          ),
          actions: _hasChangedPreferences
              ? [
                  IconButton(
                    icon: const Icon(Icons.done),
                    onPressed: () {
                      _sendResultsBack(context);
                    },
                  )
                ]
              : null,
        ),
        body: ListView(
          children: [
            SortMethodGroup(
              selectedItem: _selectedSortMethod,
              onOptionTap: (option) => setState(
                () => _selectedSortMethod = option.id,
              ),
            ),
            const Divider(),
            AccountFilterGroup(
              accounts: allAccounts.toList(),
              selectedItemsIds: _selectedAccountIds,
              onOptionTap: (option) => setState(
                () => _selectedAccountIds.toggleItem(option.id),
              ),
            ),
            const Divider(),
            MonthGroup(
              selectedDate: _selectedMonth,
              onOptionTap: (option) => setState(() {
                _selectedMonth = option;
              }),
            ),
          ],
        ),
      );
}

class SortChoiceChip extends StatefulWidget {
  final List<String> names;
  const SortChoiceChip({
    Key? key,
    required this.names,
  }) : super(key: key);

  @override
  _SortChoiceChipState createState() => _SortChoiceChipState();
}

class _SortChoiceChipState extends State<SortChoiceChip> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 5.0,
      children: List<Widget>.generate(
        widget.names.length,
        (int index) {
          return ChoiceChip(
            label: Text(widget.names[index]),
            selected: _value == index,
            onSelected: (bool selected) {
              setState(() {
                _value = index;
              });
            },
          );
        },
      ).toList(),
    );
  }
}

extension _Toggle<T> on List<T> {
  void toggleItem(T item) => contains(item) ? remove(item) : add(item);
}
