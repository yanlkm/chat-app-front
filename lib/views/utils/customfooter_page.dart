import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: 'Rooms',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/profile');
            break;
          case 1:
            Navigator.pushNamed(context, '/rooms');
            break;
          case 2:
          // Add action for Search if needed
            break;
        }
      },
    );
  }
}
