import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import 'package:myexpenses/utilities/UI_components/buttons/large_buttons.dart';
import 'package:myexpenses/utilities/formats/money_formats.dart';
import 'package:myexpenses/utilities/UI_components/tiles/account_tile.dart';
import 'package:myexpenses/utilities/UI_components/loading_widgets/loading_widget.dart';
import 'package:myexpenses/views/details/account_details.dart';
import 'package:myexpenses/views/navBar.dart';

class AccountsView extends StatefulWidget {
  const AccountsView({Key? key}) : super(key: key);

  @override
  State<AccountsView> createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView> {
  late final FirebaseAccount _accountsService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _accountsService = FirebaseAccount(userUid: userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _accountsService.allAccounts(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allAccounts = snapshot.data as Iterable<Account>;
                return NestedScrollView(
                  floatHeaderSlivers: false,
                  body: _accountScreen(allAccounts),
                  headerSliverBuilder: (context, innerBoxIsScrolled) =>
                      [_accountAppBar()],
                );
              } else {
                return loadingWidget();
              }
            default:
              return loadingWidget();
          }
        },
      ),
      drawer: const SideDrawer(),
      backgroundColor: AppColors.light100,
      floatingActionButton: _addAccountButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  SliverAppBar _accountAppBar() {
    return SliverAppBar(
      title: Text(
        'Account',
        style: AppTextStyles.title3(AppColors.dark60),
      ),
      floating: true,
      centerTitle: true,
      backgroundColor: AppColors.transparent,
      iconTheme: const IconThemeData(color: AppColors.dark100),
    );
  }

  Widget _accountScreen(Iterable<Account> accounts) {
    double sum = 0;
    accounts.toList().forEach((element) {
      sum += element.amount;
    });
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: <Widget>[
          _accountBalance(sum),
          _accountsList(accounts),
        ],
      ),
    );
  }

  Container _accountBalance(double sum) {
    return Container(
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Account Balance",
            style: AppTextStyles.regularMedium(AppColors.dark20),
          ),
          const SizedBox(height: 18.0),
          Text(
            moneyFormat(sum),
            style: AppTextStyles.title1(AppColors.dark80),
          ),
        ],
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/account_balance_background.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _accountsList(Iterable<Account> accounts) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 130),
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts.elementAt(index);
        return Column(
          children: [
            AccountTile(
              account: account,
              onTap: (account) {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        AccountDetails(account: account),
                  ),
                );
              },
            ),
            const Divider(),
          ],
        );
      },
    );
  }

  Widget _addAccountButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LargePrimaryButton(
        text: '+ Add new account',
        onPressed: () =>
            Navigator.of(context).pushNamed(createOrUpdateAccountRoute),
      ),
    );
  }
}

// onTap: () async {
//   final shouldDelete = await showDeleteDialog(context);
//   if (shouldDelete) {
//     onDeleteAccount(account);
//   }
// },

//   onDeleteAccount: (account) async {
//     await _accountsService.deleteAccount(
//         documentId: account.documentId);
//   },