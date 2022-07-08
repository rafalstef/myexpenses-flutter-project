import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/services/auth/auth_service.dart';
import 'package:myexpenses/utilities/UI_components/buttons/large_buttons.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({
    required this.email,
    Key? key,
  }) : super(key: key);

  final String email;

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            _buildTitle(),
            const SizedBox(height: 20.0),
            _buildMessage(),
            const SizedBox(height: 30.0),
            _buildSendAgainButton(),
            const SizedBox(height: 50.0),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return LargePrimaryButton(
      onPressed: () async {
        await AuthService.firebase().logOut();
        Navigator.of(context).pushNamedAndRemoveUntil(
          loginRoute,
          (route) => false,
        );
      },
      text: 'Back to Login',
    );
  }

  Widget _buildSendAgainButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () async {
          await AuthService.firebase().sendEmailVerification();
        },
        child: const Text(
          "Didn't received the email? Send again.",
          style: TextStyle(
            color: AppColors.violet100,
            fontSize: 16.0,
            decoration: TextDecoration.underline,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  _buildMessage() {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: AppTextStyles.regularMedium(AppColors.dark60),
        children: <TextSpan>[
          const TextSpan(
            text: 'We send verification message to your email ',
          ),
          TextSpan(
            text: widget.email,
            style: AppTextStyles.regularMedium(AppColors.violet80),
          ),
          const TextSpan(
            text:
                '. You can check your inbox and follow the instructions to verify your account.',
          )
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Verify your account',
        style: TextStyle(
            color: AppColors.dark80,
            fontWeight: FontWeight.w600,
            fontSize: 36.0),
        textAlign: TextAlign.left,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.transparent,
      iconTheme: const IconThemeData(color: AppColors.dark100),
      title: Text(
        'Verification',
        style: AppTextStyles.title3(AppColors.dark60),
      ),
    );
  }
}
