import 'package:flutter/material.dart';

class WelcomeLogo extends StatelessWidget {
  const WelcomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/chat-icon.png', // Image asset
      height: 200,
    );
  }
}