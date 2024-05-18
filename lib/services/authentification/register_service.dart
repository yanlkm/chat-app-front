import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/models/utils/error.dart';

class RegisterService {
  Future<dynamic> register(String username, String password, String code) async {
      // .env loading
      await dotenv.load(fileName: ".env");
      String? baseUrl = dotenv.env['BASE_URL'];

      try {
        // Création d'une instance de Dio
        final dio = Dio();

        final response = await dio.post(
          '${baseUrl!}/users',
          data: {
            'username': username,
            'password': password,
            'code': code,
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
        // Create a user object from the response
        return User.fromJson(response.data);
      } else {
        // Return an error object from the response
        return ErrorResponse.fromJson(response.data);
      }
    } catch (e) {
      // Return a generic error object
      return ErrorResponse(error: 'Connexion error. Please try again.');
    }
  }
}
