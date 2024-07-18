import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/user.dart';

class UserService {
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
            'Authorization': token,
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
        // return user instance converted from the json response
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

      // return the response message
      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Username updated successfully';
      } else {
        return response.data['error'] ?? 'Failed to update username';
      }
    } catch (e) {
      print('Failed to update username: $e');
      // throw an exception
      throw Exception('Failed to update username');
    }
  }

  // update user password
  Future<String> updatePassword(String oldPassword, String newPassword) async {
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
        '${baseUrl!}/users/$userId/password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
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
      // return the response message
      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Password updated successfully';
      } else {
        return response.data['error'] ?? 'Failed to update password';
      }
    } catch (e) {
      throw Exception('Failed to update password');
    }
  }

  // get All users
  Future<List<User>> getUsers() async {
    // load secure storage
    const secureStorage = FlutterSecureStorage();
    // get token from secure storage
    String? token = await secureStorage.read(key: 'token');
    // load .env file
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    try {
      final dio = Dio();
      final response = await dio.get(
        '${baseUrl!}/users/',
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
      // if the request succeed
      if (response.statusCode == 200) {
        return (response.data as List<dynamic>)
            .map<User>((user) => User.fromJson(user))
            .toList();
      } else {
        return [] as List<User>;
      }
    } catch (e) {
      throw Exception('Failed to fetch users');
    }
  }

  // ban user method
  Future<String> banUser(String userToBanId) async {
// load secure storage
    const secureStorage = FlutterSecureStorage();
    // get token from secure storage
    String? token = await secureStorage.read(key: 'token');
    String? userId = await secureStorage.read(key: 'userId');
    // load .env file
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    try {
      final dio = Dio();
      final response = await dio.get(
        '${baseUrl!}/users/ban/$userId/$userToBanId',
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
      // if the request succeed
      if (response.statusCode == 200) {
        return response.data['message'] ?? 'User banned successfully';
      } else {
        return response.data['error'] ?? 'Failed to ban user';
      }
    } catch (e) {
      throw Exception('Failed to ban user');
    }
  }

  // unban user method
  Future<String> unbanUser(String userToUnbanId) async {
    // load secure storage
    const secureStorage = FlutterSecureStorage();
    // get token from secure storage
    String? token = await secureStorage.read(key: 'token');
    String? userId = await secureStorage.read(key: 'userId');
    // load .env file
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    try {
      final dio = Dio();
      final response = await dio.get(
        '${baseUrl!}/users/unban/$userId/$userToUnbanId',
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
      // if the request succeed
      if (response.statusCode == 200) {
        return response.data['message'] ?? 'User unbanned successfully';
      } else {
        return response.data['error'] ?? 'Failed to ban user';
      }
    } catch (e) {
      throw Exception('Failed to unban user');
    }
  }

  // create a code
  Future<String> createRegistrationCode(String code) async {
    // load secure storage
    const secureStorage = FlutterSecureStorage();
    // get token from secure storage
    String? token = await secureStorage.read(key: 'token');
    // load .env file
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    // try to create a register code
    try {
      final dio = Dio();
      final response = await dio.post(
        '${baseUrl!}/codes',
        data: {
          'code': code,
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
      // if the request succeed
      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Code created successfully';
      } else {
        return response.data['error'] ?? 'Failed to create register code';
      }
    } catch (e) {
      throw Exception('Failed to create connection code');
    }
  }
}