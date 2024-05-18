import 'package:flutter/material.dart';
import 'package:my_app/views/utils/error_popup.dart';

import '../../controllers/authentification/login_controller.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController;

  LoginPage({super.key, required this.loginController});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In',
            style: TextStyle(color: Colors.white)), // Customizing app bar title color
        backgroundColor: Colors.blue, // Customizing app bar color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(), // Adding border
                prefixIcon: Icon(Icons.person),
              ),

            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(), // Adding border
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // check if the fields are not empty
                if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
                  ErrorDisplayIsolate.showErrorSnackBar(context, 'Please fill in all fields.');
                  return;
                }
                // Call the login method
                loginController.login(context, _usernameController.text, _passwordController.text);
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(100, 50),
                backgroundColor: Colors.blue, // Button color
                padding: const EdgeInsets.all(15), // Padding around the button text
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 18, color: Colors.white), // Text size
              ),
            ),
            const SizedBox(height: 20.0, width: 20.0),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(color: Colors.blue), // Changing text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
