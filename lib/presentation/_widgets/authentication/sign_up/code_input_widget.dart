import 'package:flutter/material.dart';

class CodeTextField extends StatelessWidget {
  final TextEditingController codeController;

  const CodeTextField({super.key, required this.codeController});

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