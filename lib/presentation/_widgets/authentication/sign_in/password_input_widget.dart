import 'package:flutter/material.dart';

// Password Text Field
class PasswordTextField extends StatelessWidget {
  // Password Controller
  final TextEditingController passwordController;
  // Constructor
  const PasswordTextField({super.key, required this.passwordController});
  // Build Method
  @override
  Widget build(BuildContext context) {
    // Return TextFormField
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
