import 'package:flutter/material.dart';

class PasswordChangeFields extends StatelessWidget {
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final VoidCallback onUpdate;

  const PasswordChangeFields({
    Key? key,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.onUpdate,
  }) : super(key: key);

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
