import 'package:flutter/material.dart';

// Sign In Button
class SignInButton extends StatelessWidget {
  // Callback
  final VoidCallback onPressed;
  // Constructor
  const SignInButton({super.key, required this.onPressed});

  // Build Method
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(120, 60),
        backgroundColor: Colors.white,
        side : const BorderSide(color: Colors.blue, width: 2),
        padding: const EdgeInsets.all(15),
      ),
      child: const Text(
        'Sign In',
        style: TextStyle(fontSize: 18, color: Colors.blue),
      ),
    );
  }
}