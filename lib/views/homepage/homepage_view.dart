import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/decorations/app_decorations.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/enums/sort_method.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/services/cloud/operation/firebase_operation.dart';
import 'package:myexpenses/utilities/formats/date_formats.dart';
import 'package:myexpenses/utilities/loading_widgets/loading_widget.dart';
import 'package:myexpenses/utilities/preference_groups/list_preferences.dart';
import 'package:myexpenses/views/homepage/homepage_widgets.dart';
import 'package:myexpenses/views/list_preferences/list_preferences_view.dart';
import 'package:myexpenses/views/navBar.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late final FirebaseOperation _operationService;
  late final FirebaseAccount _accountService;

  late final Future? fetchAllAccounts = _fetchAccounts();
  late Iterable<Account> allAccounts;

  ListPreferences? _listPreferences;
  String? choosenCategorySegment;

  int pageIndex = 0;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _operationService = FirebaseOperation();
    _accountService = FirebaseAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.homePageGradient(),
      child: Scaffold(
        drawer: const SideDrawer(),
        body: NestedScrollView(
          body: _summaryPageData(),
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) =>
              [_summaryAppBar()],
        ),
        backgroundColor: AppColors.transparent,
        floatingActionButton: _addOperationButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  void onChangedTab(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  FutureBuilder _summaryPageData() {
    return FutureBuilder(
      future: fetchAllAccounts,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (_listPreferences == null) {
              _initListPreferences();
            }
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
                      return _summaryPageView(allOperations);
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
    allAccounts = await _accountService.getAccounts(ownerUserId: userId);
  }

  void _initListPreferences() {
    List<String> accountsId = List.empty(growable: true);
    for (var account in allAccounts.toList()) {
      accountsId.add(account.documentId);
    }
    _listPreferences = ListPreferences(
      sortMethod: SortMethod.newest,
      startDate: currentMonthFirstDay,
      endDate: currentMonthLastDay,
      filteredAccountIds: accountsId,
    );
  }

  Widget _summaryPageView(Iterable<Operation> operations) {
    return HomePageWidgets(
      operations: operations,
      accounts: allAccounts,
      preferences: _listPreferences!,
    );
  }

  FloatingActionButton _addOperationButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed(createOrUpdateExpenseRoute);
      },
      backgroundColor: AppColors.violet100,
      child: const IconTheme(
        data: IconThemeData(size: 34.0, color: AppColors.light100),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _summaryAppBar() {
    return SliverAppBar(
      centerTitle: true,
      backgroundColor: AppColors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.tune, color: AppColors.light100),
          onPressed: () => _pushListPreferencesScreen(context),
        )
      ],
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
}
