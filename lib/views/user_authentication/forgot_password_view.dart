import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/auth/auth_exceptions.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/utilities/show_error_dialog.dart';
import 'package:myexpenses/utilities/show_forgot_password_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute,
              (route) => false,
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "We will send you instructions on how to reset your password by email.",
            textAlign: TextAlign.center,
          ),
          TextField(
            textAlign: TextAlign.center,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          TextButton(
            onPressed: () async {
              final email = _controller.text;
              try {
                await AuthService.firebase().sendPasswordReset(
                  toEmail: email,
                );
                await showForgotPasswordDialog(
                  context,
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'Invalid email',
                );
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  'User not found',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Password reset failed',
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
