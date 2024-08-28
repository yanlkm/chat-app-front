import 'package:flutter/material.dart';

// Update Password Widget
class UpdatePasswordWidget extends StatelessWidget {
  // Show Passwords
  final bool showPasswords;
  // Old Password and New Password Text Editing controllers
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;

  // Toggle Passwords and Update Password actions as Callback functions
  final Function onTogglePasswords;
  final Function onUpdatePassword;

  // Constructor
  const UpdatePasswordWidget({
    super.key,
    required this.showPasswords,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.onTogglePasswords,
    required this.onUpdatePassword,
  });

  // main build method
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      // Animated Slide to show Passwords if showPasswords is true
      child: AnimatedSlide(
        offset: showPasswords ? const Offset(0, 0) : const Offset(0, -0.2),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        // Animated Opacity what will show Passwords if showPasswords is true
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
