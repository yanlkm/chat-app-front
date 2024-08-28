import 'package:flutter/material.dart';

import '../../../_widgets/authentication/sign_in/sign_in_button_widget.dart';
import '../../../_widgets/authentication/sign_up/sign_up_button_widget.dart';
import '../../../_widgets/home/welcome/logo_widget.dart';
import '../../../_widgets/home/welcome/text_widget.dart';

// WelcomeView : welcome page view
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  // main build
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2), // Add space at the top
              const WelcomeLogo(),
              const SizedBox(height: 30),
              const WelcomeText(),
              const SizedBox(height: 50),
              SignUpButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
              ),
              const SizedBox(height: 20),
              SignInButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signing');
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2), // Add space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
