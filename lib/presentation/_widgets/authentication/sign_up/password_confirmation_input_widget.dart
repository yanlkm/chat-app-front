import 'package:flutter/material.dart';

class PasswordConfirmationTextField extends StatelessWidget {
  final TextEditingController passwordConfirmationController;

  const PasswordConfirmationTextField({super.key, required this.passwordConfirmationController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordConfirmationController,
      decoration: const InputDecoration(
        labelText: 'Confirm Password',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
      ),
      obscureText: true,
    );
  }
}