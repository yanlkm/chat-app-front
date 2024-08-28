import 'package:flutter/material.dart';


// PasswordConfirmationTextField
class PasswordConfirmationTextField extends StatelessWidget {
  // TextEditing controller as attribute
  final TextEditingController passwordConfirmationController;

  // Constructor
  const PasswordConfirmationTextField({super.key, required this.passwordConfirmationController});

  // build widget method
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