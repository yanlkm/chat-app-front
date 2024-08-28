import 'package:flutter/material.dart';
// Code Text Field
class CodeTextField extends StatelessWidget {
  // Code Controller
  final TextEditingController codeController;
  // Constructor
  const CodeTextField({super.key, required this.codeController});

  // Build Method
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: codeController,
      decoration: const InputDecoration(
        labelText: 'Verification Code',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.confirmation_number),
      ),
    );
  }
}