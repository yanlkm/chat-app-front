import 'package:flutter/material.dart';

// Password Change Fields
class PasswordChangeFields extends StatelessWidget {
  // Old Password and New Password Text Editing controllers
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  // Update action as a Callback function
  final VoidCallback onUpdate;

  // Constructor
  const PasswordChangeFields({
    super.key,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.onUpdate,
  });

  // main build method
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: oldPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Old Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: newPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'New Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onUpdate,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Change'),
        ),
      ],
    );
  }
}
