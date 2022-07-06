import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/auth/auth_exceptions.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/utilities/UI_components/buttons/large_buttons.dart';
import 'package:myexpenses/utilities/UI_components/input_fields/app_text_field.dart';
import 'package:myexpenses/utilities/dialogs/show_error_dialog.dart';
import 'package:myexpenses/utilities/validator/app_forms_validator.dart';
import 'package:myexpenses/views/user_authentication/sign_in_with_google.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final formKey = GlobalKey<FormState>();
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
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                _buildEmailTextField(),
                const SizedBox(height: 20.0),
                _buildPasswordTextField(),
                const SizedBox(height: 30.0),
                _buildSignUpButton(context),
                _buildBox(context),
                const SignWithGoogleButton(text: 'Sign up with Google'),
                const SizedBox(height: 20.0),
                _buildLoginHereRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildLoginHereRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Already have an account?",
          style: AppTextStyles.regularMedium(AppColors.dark20),
        ),
        TextButton(
          child: const Text(
            'Login',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: AppColors.violet100,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute,
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  _buildBox(BuildContext context) {
    return Container(
      height: 50.0,
      alignment: Alignment.center,
      child: Text(
        'Or with',
        style: AppTextStyles.smallBold(AppColors.dark20),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return LargePrimaryButton(
      text: 'Sign Up',
      onPressed: () async {
        final bool isFormValid = formKey.currentState!.validate();
        if (isFormValid) {
          final email = _email.text;
          final password = _password.text;
          try {
            await AuthService.firebase().createUser(
              email: email,
              password: password,
            );
            AuthService.firebase().sendEmailVerification();
            Navigator.of(context).pushNamed(verifyEmailRoute);
          } on WeakPasswordAuthException {
            await showErrorDialog(
              context,
              'Weak password',
            );
          } on EmailAlreadyInUseAuthException {
            await showErrorDialog(
              context,
              'Email is already in use',
            );
          } on InvalidEmailAuthException {
            await showErrorDialog(
              context,
              'This is an invalid email address',
            );
          } on GenericAuthException {
            await showErrorDialog(
              context,
              'Failed to register',
            );
          }
        }
      },
    );
  }

  AppTextFormField _buildPasswordTextField() {
    return AppTextFormField(
      textEditingController: _password,
      textInputType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      obscureText: true,
      labelText: 'Enter your password',
      errorText: 'Please enter your password.',
      validator: (value) =>
          AppFormsValidator.validateRegisterPassword(password: value),
    );
  }

  AppTextFormField _buildEmailTextField() {
    return AppTextFormField(
      textEditingController: _email,
      textInputType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      labelText: 'Enter your email',
      errorText: 'Please enter your email address.',
      validator: (value) =>
          AppFormsValidator.validateRegisterEmail(email: value),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.transparent,
      iconTheme: const IconThemeData(color: AppColors.dark100),
      title: Text('Sign Up', style: AppTextStyles.title3(AppColors.dark60)),
    );
  }
}
