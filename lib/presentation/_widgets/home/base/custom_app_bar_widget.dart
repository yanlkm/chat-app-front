import 'package:flutter/material.dart';

// Custom App Bar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Logout action as a callback function
  final VoidCallback onLogout;

  // Constructor
  const CustomAppBar({super.key, required this.onLogout});

  // main build method
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Chat App",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        strutStyle: StrutStyle(height: 1.5),
      ),
      backgroundColor: Colors.blue,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          // Logout action
          onPressed: onLogout,
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  // Preferred Size
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}