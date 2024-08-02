import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isAdmin;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: 'Rooms',
        ),
        if (isAdmin)
          const BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Admin',
          ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
