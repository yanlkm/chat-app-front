import 'package:flutter/material.dart';
import 'package:my_app/models/utils/error.dart';
import 'package:my_app/models/utils/token.dart';
import '../../services/authentification/login_service.dart';


class LoginController {
  final LoginService loginService;

  LoginController({required this.loginService});

  Future<dynamic> login(BuildContext context, String username,
      String password) async {
    try {
      final response = await loginService.login(context, username, password);

      if (response is Token) {
        return response;

      } else {
        return response;
      }
    } catch (e) {
      return ErrorResponse(error: 'Connexion error. Please try again.');
    }
  }
}
