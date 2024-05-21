import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_app/models/utils/token.dart';
import 'package:my_app/views/utils/error_popup.dart';
import '../../services/authentification/login_service.dart';


class LoginController {
  final LoginService loginService;

  LoginController({required this.loginService});

  Future<void> login(BuildContext context, String username,
      String password) async {
    try {
      final response = await loginService.login(context, username, password);

      if (response is Token) {
        // display success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User logged in successfully.'),
            duration: Duration(seconds: 3),
          ),
        );
        // treat the token response
        var token = response.token;
        // store token in secure storage
        const secureStorage = FlutterSecureStorage();
        await secureStorage.write(key :'token', value : response.token);
        // decode the token
        Map<String, dynamic> jwt = JwtDecoder.decode(token);
        // store the user id in secure storage
        await secureStorage.write(key : 'userId', value : jwt['_id']);
        // store the username in secure storage
        await secureStorage.write(key : 'username', value:  jwt['Username']);
        // redirect to home page
        Navigator.pushNamed(context, '/home');

      } else {
        ErrorDisplayIsolate.showErrorDialog(context, response.error);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to login user: $e');
      }
      ErrorDisplayIsolate.showErrorDialog(context, 'Connexion error. Please try again.');
    }
  }
}
