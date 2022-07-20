import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/decorations/app_decorations.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/enums/user_transaction_enum.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/category/category.dart';
import 'package:myexpenses/services/cloud/operation/operation.dart';
import 'package:myexpenses/utilities/UI_components/buttons/large_buttons.dart';
import 'package:myexpenses/utilities/UI_components/new_operation/description_text_field.dart';
import 'package:myexpenses/utilities/UI_components/new_operation/operation_date_choice/date_choice.dart';
import 'package:myexpenses/utilities/UI_components/preferences_sheet/one_choice_list/item_choice_group.dart';
import 'package:myexpenses/utilities/formats/date_formats.dart';
import 'package:myexpenses/utilities/UI_components/new_operation/cost_text_field.dart';

class CreateUpdateOperationView extends StatefulWidget {
  final UserTransaction userTransaction;
  final Operation? operation;
  final List<Account> accounts;
  final List<OperationCategory> categories;
  final Future<void> Function({
    required double cost,
    required String description,
    required OperationCategory category,
    required Account account,
    required DateTime date,
  }) onTapSaveButton;

  const CreateUpdateOperationView({
    Key? key,
    required this.userTransaction,
    required this.operation,
    required this.accounts,
    required this.categories,
    required this.onTapSaveButton,
  }) : super(key: key);

  @override
  State<CreateUpdateOperationView> createState() =>
      _CreateUpdateOperationViewState();
}

class _CreateUpdateOperationViewState extends State<CreateUpdateOperationView> {
  double cost = 0;
  String description = '';

  late Account selectedAccount;
  late OperationCategory selectedCategory;
  late DateTime selectedDate;

  Color get _leadingColor => (widget.userTransaction == UserTransaction.income)
      ? AppColors.green100
      : AppColors.red100;

  @override
  void initState() {
    selectedAccount = widget.accounts[0];
    selectedCategory = widget.categories[0];
    selectedDate = AppDateFormat.today;
    _initProperties();
    super.initState();
  }

  void _initProperties() {
    if (widget.operation != null) {
      Operation operation = widget.operation!;
      cost = operation.cost;
      description = operation.description;
      selectedCategory = operation.category;
      selectedAccount = operation.account;
      selectedDate = operation.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildCostWidget(),
              _buildNewOperationFields(context),
            ],
          ),
        )
      ],
    );
  }

  Padding _buildCostWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'How much?',
              textAlign: TextAlign.left,
              style: AppTextStyles.title3(
                AppColors.light80.withOpacity(0.6),
              ),
            ),
          ),
          CostTextField(
            cost: cost,
            onChanged: (value) => setState(() {
              cost = double.parse(value);
            }),
          ),
        ],
      ),
    );
  }

  Container _buildNewOperationFields(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: AppDecorations.newTransactionDecoration(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DescriptionTextField(
              description: description,
              iconColor: _leadingColor,
              onChanged: (value) => setState(() {
                description = value;
              }),
            ),
            _buildCategoryChoice(),
            _buildAccountChoice(),
            _buildDateChoice(),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  ItemChoiceGroup _buildCategoryChoice() {
    return ItemChoiceGroup(
      listTitle: 'Category',
      icon: Icon(
        Icons.bookmark_rounded,
        color: _leadingColor,
      ),
      items: widget.categories,
      selectedItem: selectedCategory,
      onOptionTap: (option) => setState(() {
        selectedCategory = widget.categories
            .firstWhere((element) => element.documentId == option);
      }),
    );
  }

  ItemChoiceGroup _buildAccountChoice() {
    return ItemChoiceGroup(
      listTitle: 'Account',
      icon: Icon(
        Icons.account_balance_wallet_rounded,
        color: _leadingColor,
      ),
      items: widget.accounts,
      selectedItem: selectedAccount,
      onOptionTap: (option) => setState(() {
        selectedAccount = widget.accounts
            .firstWhere((element) => element.documentId == option);
      }),
    );
  }

  DateChoice _buildDateChoice() {
    return DateChoice(
      date: selectedDate,
      iconColor: _leadingColor,
      onChanged: (newDate) => setState(() {
        selectedDate = newDate;
      }),
    );
  }

  LargePrimaryButton _buildSaveButton() {
    return LargePrimaryButton(
      text: 'Continue',
      onPressed: () => widget.onTapSaveButton(
        cost: cost,
        description: description,
        category: selectedCategory,
        account: selectedAccount,
        date: selectedDate,
      ),
    );
  }
}
