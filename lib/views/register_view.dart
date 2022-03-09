import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:myexpenses/constants/routes.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({ Key? key }) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        ),
      body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      textAlign: TextAlign.center,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      decoration:
                          const InputDecoration(hintText: 'Enter your email'),
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _password,
                      decoration:
                          const InputDecoration(hintText: 'Enter your password'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try{
                          final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, 
                                password: password,
                                );
                                devtools.log(userCredential.toString());
                        } on FirebaseException catch (e)
                        {
                          if(e.code == 'weak-password')
                          {
                            devtools.log('Weak password');
                          }
                          else if(e.code=='email-already-in-use')
                          {
                            devtools.log('Email already in use');
                          }
                          else if(e.code=='invalid-email')
                          {
                            devtools.log('Invalid email entered');
                          }
                          else
                          {
                            devtools.log(e.code);
                          }
                        }
                      },
                      child: const Text('Register'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                       (route) => false,
                       );},
                      child: const Text('Already registered? Login here!'),
                    )
                  ],
                ),
    );
  }
}