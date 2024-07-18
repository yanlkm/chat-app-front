import 'package:flutter/material.dart';
import 'package:my_app/controllers/authentification/register_controller.dart';
import '../../utils/error_popup.dart';


class RegisterPage extends StatelessWidget {
  // Add the registerController property
  final RegisterController registerController;

  // Add the registerController to the constructor
  RegisterPage({super.key, required this.registerController});

  // Add the TextEditingController properties
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
  TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  // Add the build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add the AppBar widget
      appBar: AppBar(
        title: const Text('Sign Up',
            style: TextStyle(color: Colors.white,)),
        backgroundColor: Colors.blue, // Customizing app bar title color
      ),
      body: Padding(
        // Add the padding
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            // Add the Column widget
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20.0),
              // Add the Text widget
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                // Add the password field
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                // Add the password confirmation field
                controller: _passwordConfirmationController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                // Add the code field
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                // Add the onPressed method to call the register method
                onPressed: () {
                  _register(context);
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 50),
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text('Sign Up',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Add the register method, this method will check state of fields, then call the register method from the registerController
  void _register(BuildContext context) {
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _codeController.text.isEmpty) {
      ErrorDisplayIsolate.showErrorSnackBar(
          context, 'Please fill in all fields.');
      return;
    }
    if (_passwordController.text != _passwordConfirmationController.text) {
      ErrorDisplayIsolate.showErrorSnackBar(
          context, 'Passwords do not match.');
      return;
    }
    registerController.register(
      context,
      _usernameController.text,
      _passwordController.text,
      _codeController.text,
    );
  }
}
