import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../models/user.dart';
import '../../cubits/profile/password_cubit.dart';
import 'update_password_widget.dart';

class UserProfileWidget extends StatefulWidget {
  final User user;
  final bool isEditingUsername;
  final TextEditingController usernameController;
  final Function onEditPressed;
  final Function updatePassword;
  final Function onSavePressed;

  UserProfileWidget({
    super.key,
    required this.user,
    required this.isEditingUsername,
    required this.usernameController,
    required this.onEditPressed,
    required this.onSavePressed,
    required this.updatePassword,
  });

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  bool showPasswords = false;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  void onTogglePasswords() {
    setState(() {
      showPasswords = !showPasswords;
    });
  }

  void onUpdatePassword() {
    widget.updatePassword(
      oldPasswordController.text,
      newPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('MMMM dd, yyyy');
    String updatedAtFormatted = dateFormat.format(widget.user.updatedAt!);
    // Set the username controller text
    widget.usernameController.text = widget.user.username!;

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
            Column(
              children: [
                widget.isEditingUsername
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: 250,
                              child: TextField(
                                controller: widget.usernameController,
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
                            onPressed: () => widget.onSavePressed(),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.user.username!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => widget.onEditPressed(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.vpn_key, color: Colors.blue),
                            onPressed: () => onTogglePasswords(),
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
            const SizedBox(height: 20),
            if (showPasswords)
              BlocListener<PasswordCubit, PasswordState>(
                listener: (context, state) {
                  if (state is PasswordUpdated) {
                    setState(() {
                      widget.user.updatedAt = DateTime.now();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                    oldPasswordController.clear();
                    newPasswordController.clear();
                    showPasswords = false;
                  } else if (state is PasswordError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                child: UpdatePasswordWidget(
                  showPasswords: showPasswords,
                  oldPasswordController: oldPasswordController,
                  newPasswordController: newPasswordController,
                  onTogglePasswords: onTogglePasswords,
                  onUpdatePassword: onUpdatePassword,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
