import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LogoutService {

  Future<String> Logout() async {
    // load secure storage
     const secureStorage = FlutterSecureStorage();
    // get token from secure storage

    String? token = await secureStorage.read(key: 'token');

    // load .env file
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];

    final dio = Dio();
    try {
      // send a request to the server with dio
      final response = await dio.get(
        '${baseUrl!}/auth/logout',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token,
          },
          followRedirects: true,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      // Check the response
      if (response.statusCode == 200) {
        return 'Logout successful';
      } else {
        // Return an error object from the response
        throw Exception('Failed to logout');
      }
    } catch (e) {
      // Return a generic error object
      throw Exception('Failed to logout: $e');
    }
  }
}
