import 'package:flutter/material.dart';

class UsernameTextField extends StatelessWidget {
  final TextEditingController usernameController;

  const UsernameTextField({super.key, required this.usernameController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: usernameController,
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
    );
  }
}
