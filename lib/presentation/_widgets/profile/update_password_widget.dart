import 'package:flutter/material.dart';

class UpdatePasswordWidget extends StatelessWidget {
  final bool showPasswords;
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final Function onTogglePasswords;
  final Function onUpdatePassword;

  const UpdatePasswordWidget({
    super.key,
    required this.showPasswords,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.onTogglePasswords,
    required this.onUpdatePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showPasswords)
          Column(
            children: [
              const SizedBox(height: 20),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
                onPressed: () => onUpdatePassword(),
                child: const Text('Update Password'),
              ),
            ],
          ),
      ],
    );
  }
}