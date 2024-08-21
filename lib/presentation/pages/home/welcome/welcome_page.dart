import 'package:flutter/material.dart';

import '../../../views/home/welcome/welcome_view.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Chat App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          strutStyle: StrutStyle(height: 1.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0, // No shadow
      ),
      body: const WelcomeView(),
    );
  }
}
