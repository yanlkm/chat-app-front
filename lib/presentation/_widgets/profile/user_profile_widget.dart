import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';

// UserProfileWidget
class UserProfileWidget extends StatelessWidget {
  // UserEntity, isEditingUsername, showPasswords as attributes
  final UserEntity user;
  final bool isEditingUsername;
  final bool showPasswords;

  // usernameController, oldPasswordController, newPasswordController as controllers
  final TextEditingController usernameController;
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;

  //  onEditPressed, onSavePressed, onTogglePasswords as functions
  final VoidCallback onEditPressed;
  final VoidCallback onSavePressed;
  final VoidCallback onTogglePasswords;

  // Constructor
  const UserProfileWidget({
    super.key,
    required this.user,
    required this.isEditingUsername,
    required this.usernameController,
    required this.onEditPressed,
    required this.onSavePressed,
    required this.onTogglePasswords,
    required this.showPasswords,
    required this.oldPasswordController,
    required this.newPasswordController,
  });

  // main build method
  @override
  Widget build(BuildContext context) {
    // DateFormat to format the updatedAt date
    DateFormat dateFormat = DateFormat('MMMM dd, yyyy ss:mm');
    String updatedAtFormatted = dateFormat.format(user.updatedAt!);
    // set the username in the controller
    usernameController.text = user.username!;

    // Card to show the user profile
    return Card(
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  color: Colors.transparent,
                ),
                Positioned(
                  top: 0,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(
                      Icons.person,
                      color: Colors.grey.shade800,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Column to show the username and last updated date
            Column(
              children: [
                // if isEditingUsername is true show the TextField to edit the username
                isEditingUsername
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 250,
                        child: TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Enter new username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon:
                      const Icon(Icons.check, color: Colors.blueGrey),
                      onPressed: onSavePressed,
                    ),
                  ],
                )
                    // else show the username with edit and toggle password buttons
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.username!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: onEditPressed,
                    ),
                    IconButton(
                      icon: const Icon(Icons.vpn_key, color: Colors.blue),
                      onPressed: onTogglePasswords,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Last updated: $updatedAtFormatted',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
