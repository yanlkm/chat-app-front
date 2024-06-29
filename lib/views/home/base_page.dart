import 'package:flutter/material.dart';
import 'package:my_app/views/home/welcome_page.dart';
import '../../controllers/authentification/logout_controller.dart';


class BasePage extends StatelessWidget {
  // Add the child and showFooter properties
  final Widget child;
  final bool showFooter;
  final LogoutController logoutController;
  const BasePage({required this.child, this.showFooter = true, super.key, required this.logoutController});

  // Add the build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add the AppBar widget
      appBar: AppBar(
        // Add the title
        title: const Text("Chat App",
        // Add the styles
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
        // Add the actions
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            // Add the onPressed method to logout
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
