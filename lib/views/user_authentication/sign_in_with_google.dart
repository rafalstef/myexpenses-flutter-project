import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/auth/auth_exceptions.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/utilities/UI_components/buttons/google_button.dart';
import 'package:myexpenses/utilities/dialogs/show_error_dialog.dart';

class SignWithGoogleButton extends StatelessWidget {
  const SignWithGoogleButton({
    required this.text,
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return GoogleButton(
      text: text,
      onPressed: () async {
        try {
          await AuthService.firebase().signInWithGoogle();
          Navigator.of(context).pushNamedAndRemoveUntil(
            summaryViewRoute,
            (route) => false,
          );
        } on GenericAuthException {
          await showErrorDialog(
            context,
            'Google Sign-in failed',
          );
        }
      },
    );
  }
}
