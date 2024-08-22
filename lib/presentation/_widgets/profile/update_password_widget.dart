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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnimatedSlide(
        offset: showPasswords ? const Offset(0, 0) : const Offset(0, -0.2),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        child: AnimatedOpacity(
          opacity: showPasswords ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Visibility(
            visible: showPasswords,
            child: Card(
              color: Colors.white,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
