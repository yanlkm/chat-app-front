import 'package:flutter/material.dart';

// Import the WelcomePage widget
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  // Add the build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add the AppBar widget
      appBar: AppBar(
        title: const Text('Welcome to Chat App'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0, // No shadow
      ),
      // Add the body : SingleChildScrollView, Center, Padding, Column, Image, Text, ElevatedButton, OutlinedButton
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2), // Add space at the top
                Image.asset(
                  // Add the image asset
                  'images/chat-icon.png', // Image
                  height: 200,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Join the Chat!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'ChatApp lets you chat with in real-time. Sign up now to get started!',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  // Add the onPressed method to navigate to the signup page
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () {
                    // Navigate to the signing page
                    Navigator.pushNamed(context, '/signing');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(color: Colors.blueAccent),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2), // Add space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
