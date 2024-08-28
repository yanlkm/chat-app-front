import 'package:flutter/material.dart';

// Password Text Field
class PasswordTextField extends StatelessWidget {
  // Text Editing controller
  final TextEditingController passwordController;

  // Constructor
  const PasswordTextField({super.key, required this.passwordController});

  // main build method
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
      ),
      obscureText: true,
    );
  }
}