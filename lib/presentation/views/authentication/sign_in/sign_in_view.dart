import 'package:flutter/material.dart';
import '../../../_widgets/authentication/sign_in/password_input_widget.dart';
import '../../../_widgets/authentication/sign_in/sign_in_button_widget.dart';
import '../../../_widgets/authentication/sign_in/username_input_widget.dart';

class SignInView extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onSignInPressed;
  final VoidCallback onSignUpPressed;

  const SignInView({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.onSignInPressed,
    required this.onSignUpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UsernameTextField(usernameController: usernameController),
          const SizedBox(height: 20.0),
          PasswordTextField(passwordController: passwordController),
          const SizedBox(height: 20.0),
          SignInButton(onPressed: onSignInPressed),
          const SizedBox(height: 20.0, width: 20.0),
          TextButton(
            onPressed: onSignUpPressed,
            child: const Text(
              'Don\'t have an account? Sign Up',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
