import 'package:flutter/material.dart';
import 'package:my_app/views/welcome_page.dart';

import '../controllers/authentification/logout_controller.dart';


class BasePage extends StatelessWidget {
  final Widget child;
  final bool showFooter;
  final LogoutController logoutController;
  const BasePage({required this.child, this.showFooter = true, super.key, required this.logoutController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),

          strutStyle: StrutStyle(
            height: 1.5,
          ),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await logoutController.Logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const WelcomePage()));
            },
          ),
        ],
        automaticallyImplyLeading : false,
      ),
      body: child
    );
  }
}
