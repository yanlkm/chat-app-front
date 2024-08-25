import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onLogout;

  const CustomAppBar({super.key, required this.onLogout});

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
          onPressed: onLogout,
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}