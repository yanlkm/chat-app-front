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
      if (response.statusCode == 200) {
        return 'Logout successful';
      } else {
        throw Exception('Failed to logout');
      }
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
}
