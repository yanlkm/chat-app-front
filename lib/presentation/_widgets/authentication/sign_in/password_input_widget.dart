import 'package:flutter/material.dart';
class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordController;

  const PasswordTextField({super.key, required this.passwordController});

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
