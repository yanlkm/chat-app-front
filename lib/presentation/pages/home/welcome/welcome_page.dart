import 'package:flutter/material.dart';

import '../../../views/home/welcome/welcome_view.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Chat App'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0, // No shadow
      ),
      body: const WelcomeView(),
    );
  }
}
