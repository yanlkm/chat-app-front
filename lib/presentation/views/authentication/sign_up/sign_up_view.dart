import 'package:flutter/material.dart';

import '../../../_widgets/authentication/sign_in/password_input_widget.dart';
import '../../../_widgets/authentication/sign_in/username_input_widget.dart';
import '../../../_widgets/authentication/sign_up/code_input_widget.dart';
import '../../../_widgets/authentication/sign_up/password_confirmation_input_widget.dart';
import '../../../_widgets/authentication/sign_up/sign_up_button_widget.dart';


class SignUpView extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  final TextEditingController codeController;
  final VoidCallback onSignUpPressed;

  const SignUpView({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.codeController,
    required this.onSignUpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20.0),
          UsernameTextField(usernameController: usernameController),
          const SizedBox(height: 20.0),
          PasswordTextField(passwordController: passwordController),
          const SizedBox(height: 20.0),
          PasswordConfirmationTextField(passwordConfirmationController: passwordConfirmationController),
          const SizedBox(height: 20.0),
          CodeTextField(codeController: codeController),
          const SizedBox(height: 20.0),
          SignUpButton(onPressed: onSignUpPressed),
        ],
      ),
    );
  }
}
