import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/auth/auth_exceptions.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/utilities/UI_components/app_bars/custom_app_bars.dart';
import 'package:myexpenses/utilities/UI_components/buttons/large_buttons.dart';
import 'package:myexpenses/utilities/UI_components/input_fields/app_text_field.dart';
import 'package:myexpenses/utilities/dialogs/show_error_dialog.dart';
import 'package:myexpenses/utilities/validator/app_forms_validator.dart';
import 'package:myexpenses/views/user_authentication/sign_in_with_google.dart';
import 'package:myexpenses/views/user_authentication/verify_email_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: CustomAppBar.transparent(
        title: 'Login',
        textColor: AppColors.dark60,
      ),
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
                _buildLoginButton(context),
                const SizedBox(height: 30.0),
                _buildForgotPasswordButton(context),
                _buildSignUp(context),
                const SizedBox(height: 30.0),
                const SignWithGoogleButton(text: 'Sign in with Google'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildSignUp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account yet?",
          style: AppTextStyles.regularMedium(AppColors.dark20),
        ),
        TextButton(
          child: const Text(
            'Sign up',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: AppColors.violet100,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  TextButton _buildForgotPasswordButton(BuildContext context) {
    return TextButton(
      child: Text(
        'Forgot password?',
        style: AppTextStyles.title3(AppColors.violet100),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(
          forgotPasswordRoute,
        );
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return LargePrimaryButton(
      text: 'Login',
      onPressed: () async {
        final bool isFormValid = formKey.currentState!.validate();
        if (isFormValid) {
          final email = _email.text;
          final password = _password.text;
          try {
            await AuthService.firebase().logIn(
              email: email,
              password: password,
            );
            final user = AuthService.firebase().currentUser;
            if (user?.isEmailVerified ?? false) {
              //user's email is verified
              Navigator.of(context).pushNamedAndRemoveUntil(
                summaryViewRoute,
                (route) => false,
              );
            } else {
              // user's email is NOT verified
              _navigateToVerifyEmail(email: email);
            }
          } on UserNotFoundAuthException {
            await showErrorDialog(
              context,
              'User not found',
            );
          } on WrongPasswordAuthException {
            await showErrorDialog(
              context,
              'Wrong credentials',
            );
          } on GenericAuthException {
            await showErrorDialog(
              context,
              'Authentication error',
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
      labelText: 'Password',
      errorText: 'Please enter your password.',
      validator: (value) =>
          AppFormsValidator.validateLoginPassword(password: value),
    );
  }

  AppTextFormField _buildEmailTextField() {
    return AppTextFormField(
      textEditingController: _email,
      textInputType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      labelText: 'Email',
      errorText: 'Please enter your email address.',
      validator: (value) => AppFormsValidator.validateLoginEmail(email: value),
    );
  }

  void _navigateToVerifyEmail({required String email}) {
    final route = MaterialPageRoute<void>(
      builder: (_) => VerifyEmailView(email: email),
    );
    Navigator.of(context).push(route);
  }
}
