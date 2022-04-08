import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/services/cloud/account/account.dart';
import 'package:myexpenses/services/cloud/account/firebase_account.dart';
import 'package:myexpenses/utilities/generics/get_arguments.dart';

class CreateUpdateAccountView extends StatefulWidget {
  const CreateUpdateAccountView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateUpdateAccountView> {
  Account? _account;
  late final FirebaseAccount _accountsService;
  late final TextEditingController _nameController;
  late final TextEditingController _ammountController;
  bool _includeValue = false;

  @override
  void initState() {
    _accountsService = FirebaseAccount();
    _nameController = TextEditingController();
    _ammountController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ammountController.dispose();
    super.dispose();
  }

  Future<void> _saveAccount() async {
    final account = _account;
    final newName = _nameController.text;
    final newAmmount = double.parse(_ammountController.text);

    if (newName.isEmpty) {
      return;
    }

    if (_account == null) {
      final currentUser = AuthService.firebase().currentUser;
      final userId = currentUser!.id;
      final newAccount =
          await _accountsService.createNewAccount(ownerUserId: userId);
      _account = newAccount;
    }

    await _accountsService.updateAccount(
      documentId: account!.documentId,
      name: newName,
      ammount: newAmmount,
      includeToBalance: _includeValue,
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      accountsViewRoute,
      (_) => false,
    );
  }

  Future<Account?> getExistingAccount(BuildContext context) async {
    final widgetAccount = context.getArgument<Account>();

    if (widgetAccount == null) {
      return null;
    }

    _account = widgetAccount;
    _nameController.text = widgetAccount.name;
    _ammountController.text = widgetAccount.amount.toString();
    return widgetAccount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Account'),
      ),
      body: FutureBuilder(
        future: getExistingAccount(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Account name',
                    ),
                  ),
                  TextField(
                    controller: _ammountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        try {
                          final text = newValue.text;
                          if (text.isNotEmpty) double.parse(text);
                          return newValue;
                          // ignore: empty_catches
                        } catch (e) {}
                        return oldValue;
                      }),
                    ],
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: 'Ammount',
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Include in balance'),
                    value: _includeValue,
                    onChanged: (value) {
                      setState(() {
                        _includeValue = value;
                      });
                    },
                    activeTrackColor: const Color.fromARGB(255, 89, 119, 255),
                    activeColor: const Color.fromARGB(255, 25, 28, 185),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _saveAccount();
                    },
                    child: const Text('Save'),
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
