import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/enums/sort_method.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/services/cloud/operation/firebase_operation.dart';
import 'package:myexpenses/utilities/loading_widgets/loading_widget.dart';
import 'package:myexpenses/utilities/preference_groups/list_preferences.dart';
import 'package:myexpenses/views/chart/operation_chart_view.dart';
import 'package:myexpenses/views/homepage/list_preferences_view.dart';
import 'package:myexpenses/views/navBar.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import 'package:myexpenses/views/homepage/summary_list_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    show SmoothPageIndicator, SlideEffect;

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
  String? choosenCategorySegment;

  final PageController _pageController = PageController(initialPage: 0);

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _operationService = FirebaseOperation();
    _accountService = FirebaseAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _summaryAppBar(),
        floatingActionButton: _addOperationButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        drawer: const SideDrawer(),
        body: _summaryPageData(),
      ),
    );
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
      preferedMonth: DateTime.now(),
      filteredAccountIds: accountsId,
    );
  }

  Widget _summaryPageView(Iterable<Operation> operations) {
    final List<Operation> expenses =
        operations.where((element) => !element.category!.isIncome).toList();
    final List<Operation> incomes =
        operations.where((element) => element.category!.isIncome).toList();

    return TabBarView(
      children: [
        SummaryListView(
          operations: operations,
          accounts: allAccounts,
          preferences: _listPreferences!,
          categorySegment: choosenCategorySegment,
        ),
        Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 18)),
            Expanded(
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                children: [
                  OperationChartView(
                    title: 'Expenses',
                    operations: expenses,
                    onTapCategorySegment: (value) =>
                        setState((() => choosenCategorySegment = value)),
                  ),
                  OperationChartView(
                    title: 'Incomes',
                    operations: incomes,
                    onTapCategorySegment: (value) =>
                        setState((() => choosenCategorySegment = value)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SmoothPageIndicator(
                axisDirection: Axis.vertical,
                controller: _pageController,
                count: 2,
                effect: const SlideEffect(
                  activeDotColor: Colors.blue,
                  spacing: 10,
                  dotHeight: 8,
                  dotWidth: 8,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  FloatingActionButton _addOperationButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed(createOrUpdateExpenseRoute);
      },
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add),
    );
  }

  AppBar _summaryAppBar() {
    return AppBar(
      title: const Text('Summary'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.tune, color: Colors.white),
          onPressed: () => _pushListPreferencesScreen(context),
        )
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(20),
        child: TabBar(
          labelPadding: EdgeInsets.only(bottom: 3),
          tabs: [
            Icon(Icons.home, size: 22),
            Icon(Icons.pie_chart, size: 22),
          ],
        ),
      ),
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
