import 'package:flutter/material.dart';
import 'package:myexpenses/constants/routes.dart';

Future<void> showForgotPasswordDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Please check your email',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        content: const Text(
            "We've sent you a password reset link on email adress. If you don't see it, check your spam folder or try again.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
