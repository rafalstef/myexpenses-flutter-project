import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/enums/sort_method.dart';
import 'package:myexpenses/enums/user_transaction_enum.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/operation/firebase_operation.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/utilities/UI_components/app_bars/custom_app_bars.dart';
import 'package:myexpenses/utilities/UI_components/loading_widgets/loading_widget.dart';
import 'package:myexpenses/utilities/UI_components/no_operations_widget.dart/no_operation_widget.dart';
import 'package:myexpenses/utilities/UI_components/operations_lists/grouped_operations.dart';
import 'package:myexpenses/utilities/UI_components/tiles/tile_icon.dart';
import 'package:myexpenses/utilities/formats/money_formats.dart';
import 'package:myexpenses/views/list_preferences/list_preferences.dart';

class AccountDetails extends StatefulWidget {
  final Account account;

  const AccountDetails({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  State<AccountDetails> createState() => AccountDetailsState();
}

class AccountDetailsState extends State<AccountDetails> {
  Account get _account => widget.account;
  String get userId => AuthService.firebase().currentUser!.id;

  late final FirebaseOperation _operationService;

  late final Iterable<Operation> _operations;
  late final ListPreferences _preferences;

  late final Future? fetchOperations = _fetchOperations();

  Future<void> _fetchOperations() async {
    _operations =
        await _operationService.getOperations(preferences: _preferences);
  }

  @override
  void initState() {
    _operationService = FirebaseOperation(userUid: userId);
    _preferences = ListPreferences(
      userTransactions: [UserTransaction.expense, UserTransaction.income],
      sortMethod: SortMethod.newest,
      startDate: DateTime(2022, 1, 1),
      endDate: DateTime.now(),
      filteredAccountIds: [_account.documentId],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: FutureBuilder(
        future: fetchOperations,
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return NestedScrollView(
                body: _buildPageData(),
                floatHeaderSlivers: false,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  CustomAppBar.accountDetail(
                    onTapEdit: () => Navigator.of(context).pushNamed(
                      createOrUpdateAccountRoute,
                      arguments: _account,
                    ),
                  ),
                ],
              );
            default:
              return loadingWidget();
          }
        }),
      ),
    );
  }

  Widget _buildPageData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildAccountInfo(),
          _buildAccountOperations(),
        ],
      ),
    );
  }

  SizedBox _buildAccountInfo() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.28,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          TileIcon(
            icon: _account.icon,
            iconColor: _account.color,
            containerColor: _account.color.withOpacity(0.1),
          ),
          const SizedBox(height: 12.0),
          Text(
            _account.name,
            style: AppTextStyles.title2(AppColors.dark100),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16.0),
          Text(
            moneyFormat(_account.amount),
            style: AppTextStyles.title1(AppColors.dark60),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget _buildAccountOperations() => (_operations.isNotEmpty)
      ? Expanded(
          child: GroupedOperations(
            operations: _operations.toList(),
            sortMethod: _preferences.sortMethod,
          ),
        )
      : const NoOperations();
}
