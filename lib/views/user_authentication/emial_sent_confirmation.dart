import 'package:flutter/material.dart';
import 'package:myexpenses/config/styles/colors/app_colors.dart';
import 'package:myexpenses/config/styles/text_styles/app_text_styles.dart';
import 'package:myexpenses/constants/routes.dart';
import 'package:myexpenses/utilities/UI_components/buttons/large_buttons.dart';

class EmailSentConfirmation extends StatelessWidget {
  const EmailSentConfirmation({
    required this.email,
    Key? key,
  }) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildActionButton(context),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            _buildImage(),
            _buildTitle(),
            const SizedBox(height: 30.0),
            _buildMessage(),
          ],
        ),
      ),
    );
  }

  RichText _buildMessage() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.regularMedium(AppColors.dark60),
        children: <TextSpan>[
          const TextSpan(
            text: 'Check your email ',
          ),
          TextSpan(
            text: email,
            style: AppTextStyles.regularSemiBold(AppColors.dark100),
          ),
          const TextSpan(
            text: ' and follow the instructions to reset your password.',
          )
        ],
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      'Your email is on the way',
      style: AppTextStyles.title2(AppColors.dark100),
      textAlign: TextAlign.center,
    );
  }

  Padding _buildImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Image.asset(
        'assets/images/email_sent_image.png',
      ),
    );
  }

  Padding _buildActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: LargePrimaryButton(
        text: 'Back to Login',
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            loginRoute,
            (route) => false,
          );
        },
      ),
    );
  }
}
