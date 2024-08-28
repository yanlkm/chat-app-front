import 'package:flutter/material.dart';

// Sign Up Button
class SignUpButton extends StatelessWidget {
  // SignUp submit action as a Callback function
  final VoidCallback onPressed;

  // constructor
  const SignUpButton({super.key, required this.onPressed});

  // main build widget method
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(120, 60),
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.all(15),
      ),
      child: const Text(
        'Sign Up',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
