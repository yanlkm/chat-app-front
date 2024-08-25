import 'package:flutter/material.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';
import 'package:my_app/presentation/cubits/home/base/base_page_cubit.dart';
import 'package:my_app/views/home/welcome_page.dart';


class BasePage extends StatelessWidget {
  // Add the child and showFooter properties
  final Widget child;
  final bool showFooter;
  final AuthUseCases authUseCases;
  const BasePage({required this.child, required this.authUseCases, this.showFooter = true, super.key});

  // Add the build method
  @override
  Widget build(BuildContext context) {
    // initialize the cubit
    final cubit = BasePageCubit(authUseCases : authUseCases);
    // return the Scaffold widget
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
              await cubit.logoutUser();
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
