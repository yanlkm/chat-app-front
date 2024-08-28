import 'package:flutter/material.dart';

// Custom Bottom Navigation Bar
class CustomBottomNavigationBar extends StatelessWidget {
  //  Current Index to keep track of the current index
  final int currentIndex;
  // On Tap action as a callback function
  final ValueChanged<int> onTap;
  // isAdmin to check if the user is admin or not
  final bool isAdmin;

  // Constructor
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isAdmin,
  });

  // main build method
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
        // Show Admin tab only if the user is admin
        if (isAdmin)
          const BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Admin',
          ),
      ],
      // Current Index and On Tap action
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
