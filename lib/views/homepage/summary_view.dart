import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/enums/sort_method.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/services/cloud/operation/firebase_operation.dart';
import 'package:myexpenses/utilities/preference_groups/list_preferences.dart';
import 'package:myexpenses/views/homepage/list_preferences_view.dart';
import 'package:myexpenses/views/navBar.dart';
import '../../services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import 'package:myexpenses/views/homepage/summary_list_view.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({Key? key}) : super(key: key);

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  late final FirebaseOperation _operationService;
  late final FirebaseAccount _accountService;

  late final Future? fetchAllAccounts = _fetchAccounts();
  late Iterable<Account> allAccounts;

  ListPreferences? _listPreferences;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _operationService = FirebaseOperation();
    _accountService = FirebaseAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.tune,
              color: Colors.white,
            ),
            onPressed: () {
              _pushListPreferencesScreen(context);
            },
          ),
        ],
      ),
      drawer: const SideDrawer(),
      body: FutureBuilder(
        future: fetchAllAccounts,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (_listPreferences == null) {
                _initListPreferences();
              }
              return StreamBuilder(
                stream: _accountService.allAccounts(ownerUserId: userId),
                builder: (context, snapshot) {
                  allAccounts = (snapshot.data != null)
                      ? snapshot.data as Iterable<Account>
                      : const Iterable.empty();
                  return StreamBuilder(
                    stream: _operationService.allOperations(
                      ownerUserId: userId,
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
                            return SummaryListView(
                              operations: allOperations,
                              accounts: allAccounts,
                              preferences: _listPreferences!,
                            );
                          } else {
                            return _loading();
                          }
                        default:
                          return _loading();
                      }
                    },
                  );
                },
              );
            default:
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(createOrUpdateExpenseRoute);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future? _fetchAccounts() async {
    allAccounts = await _accountService.getAccounts(ownerUserId: userId);
  }

  void _initListPreferences() {
    List<String> accountsId = List.empty(growable: true);
    for (var account in allAccounts.toList()) {
      accountsId.add(account.documentId);
    }
    _listPreferences = ListPreferences(
      sortMethod: SortMethod.newest,
      preferedMonth: DateTime.now(),
      filteredAccountIds: accountsId,
    );
  }

  Future<void> _pushListPreferencesScreen(BuildContext context) async {
    final route = MaterialPageRoute<ListPreferences>(
      builder: (_) => ListPreferencesView(
        preferences: _listPreferences,
        allAccounts: allAccounts,
      ),
      fullscreenDialog: false,
    );
    final newPreferences = await Navigator.of(context).push(route);
    if (newPreferences != null) {
      setState(() {
        _listPreferences = newPreferences;
      });
    }
  }

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
