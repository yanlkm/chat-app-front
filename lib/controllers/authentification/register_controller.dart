import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/services/authentification/register_service.dart';
import 'package:my_app/views/utils/error_popup.dart';

import '../../models/utils/error.dart';
import '../../models/user.dart';

class RegisterController {
  final RegisterService registerService;

  RegisterController({required this.registerService});

  Future<void> register(BuildContext context, String username, String password, String code) async {
    try {
      // Call the register service
      final result = await registerService.register(username, password, code);

      if (result is User) {
        // Display the success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User registered successfully. You can now sign in.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (result is ErrorResponse) {
        // Display the error message
        ErrorDisplayIsolate.showErrorDialog(context, result.error);
      } else {
        // Not handled error
        ErrorDisplayIsolate.showErrorDialog(context, 'An error occurred. Please try again.');
      }
    } catch (e) {
      // Debug mode
      if (kDebugMode) {
        print('Failed to register user: $e');
      }
      ErrorDisplayIsolate.showErrorDialog(context, 'An error occurred. Please try again.');
    }
  }
}
