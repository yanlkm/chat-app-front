import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/models/room.dart';

class UserRoomsService {
  Future<List<Room>?> getUserRooms() async {
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
        '${baseUrl!}/rooms/user/$userId',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token,
          },
          followRedirects: true, // enable redirection
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data; // Directly use response.data
        if (kDebugMode) {
          print(data);
        }
        // Check if rooms key exists and is not null
        if (data['rooms'] != null) {
          List<Room> rooms = (data['rooms'] as List)
              .map((room) {
            return Room.fromJson(room as Map<String, dynamic>);
          })
              .toList();

          if (kDebugMode) {
            print(rooms);
          }
          return rooms;
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load user rooms 1');
      }
    } catch (e) {
      throw Exception('Failed to get user rooms 2 : $e');
    }
  }
}
