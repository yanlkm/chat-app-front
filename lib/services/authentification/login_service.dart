import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/utils/error.dart';
import '../../models/utils/token.dart';

class LoginService {
  // Add the login method
  Future<dynamic> login(BuildContext context, String username, String password) async {
    // .env loading
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    // send a request to the server with dio
    try {
      // Create a Dio instance
      final dio = Dio();

      final response = await dio.post(
        '${baseUrl!}/auth/login',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          followRedirects: true, // enabler redirection
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      // Check the response
      if (response.statusCode == 200) {
        // return token class from the json response
        return Token.fromJson(response.data);
      } else {
        // Return an error object from the response
        return ErrorResponse.fromJson(response.data);
      }
    } catch (e) {
      // Return a generic error object
      return ErrorResponse(error: 'Connexion error. Please try again. $e');
    }
  }


}