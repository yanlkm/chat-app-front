import 'package:flutter/material.dart';

// Username Text Field
class UsernameTextField extends StatelessWidget {
  // Username Controller
  final TextEditingController usernameController;
  // Constructor
  const UsernameTextField({super.key, required this.usernameController});

  // Build Method
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
