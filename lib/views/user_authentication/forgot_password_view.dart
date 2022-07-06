import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/services/auth/auth_exceptions.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/utilities/UI_components/buttons/large_buttons.dart';
import 'package:myexpenses/utilities/UI_components/input_fields/app_text_field.dart';
import 'package:myexpenses/utilities/dialogs/show_error_dialog.dart';
import 'package:myexpenses/views/user_authentication/emial_sent_confirmation.dart';
import 'package:myexpenses/utilities/validator/app_forms_validator.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final formKey = GlobalKey<FormState>();
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
                _message(),
                const SizedBox(height: 40.0),
                _emailField(),
                const SizedBox(height: 30.0),
                _continueButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LargePrimaryButton _continueButton(BuildContext context) {
    return LargePrimaryButton(
      text: 'Continue',
      onPressed: () async {
        final isEmailValid = formKey.currentState!.validate();
        if (isEmailValid) {
          final email = _controller.text;
          try {
            await AuthService.firebase().sendPasswordReset(toEmail: email);
            _navigateToEmailConfirmation(email: email);
          } on InvalidEmailAuthException {
            await showErrorDialog(context, 'Invalid email');
          } on UserNotFoundAuthException {
            await showErrorDialog(context, 'User not found');
          } on GenericAuthException {
            await showErrorDialog(context, 'Password reset failed');
          }
        }
      },
    );
  }

  AppTextFormField _emailField() {
    return AppTextFormField(
      textEditingController: _controller,
      textInputType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      labelText: 'Email',
      errorText: 'Please enter your email address.',
      validator: (value) => AppFormsValidator.validateLoginEmail(email: value),
    );
  }

  Text _message() {
    return Text(
      "Don't worry.\nEnter your email and we'll send you a link to reset your password.",
      style: AppTextStyles.title2(AppColors.dark100),
      textAlign: TextAlign.left,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.transparent,
      iconTheme: const IconThemeData(color: AppColors.dark100),
      title: Text(
        'Forgot Password',
        style: AppTextStyles.title3(AppColors.dark60),
      ),
    );
  }

  void _navigateToEmailConfirmation({required String email}) {
    final route = MaterialPageRoute<void>(
      builder: (_) => EmailSentConfirmation(email: email),
    );
    Navigator.of(context).push(route);
  }
}
