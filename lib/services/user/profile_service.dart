import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/user.dart';

class ProfileService {
  // get user profile information
  Future<User> getUserProfile() async {
    // load secure storage
    const secureStorage = FlutterSecureStorage();
    // get token and userid from secure storage
    String? token = await secureStorage.read(key: 'token');
    String? userId = await secureStorage.read(key: 'userId');
    // load .env file
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    try {
      final dio = Dio();
      final response = await dio.get(
        '${baseUrl!}/users/$userId',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization' : token,
          },
          followRedirects: true, // enabler redirection
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        // debug mode
        if (kDebugMode) {
          print(response.data);

        }
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      // debug mode
      if (kDebugMode) {
        print('Failed to get user profile: $e');
      }
      throw Exception('Failed to get user profile');
    }
  }

  //  update username
  Future<String> updateUsername(String username) async {
    // load secure storage
    const secureStorage = FlutterSecureStorage();
    // get token from secure storage
    String? token = await secureStorage.read(key: 'token');
    // get user id from secure storage
    String? userId = await secureStorage.read(key: 'userId');
    // load .env file
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    try {
      final dio = Dio();
      final response = await dio.put(
        '${baseUrl!}/users/$userId',
        data: {
          'username': username,
        },
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
        return response.data['message']?? 'Username updated successfully';
      } else {
        return response.data['error']?? 'Failed to update username';
      }
    } catch (e) {
      print('Failed to update username: $e');
      throw Exception('Failed to update username');
    }
  }
}