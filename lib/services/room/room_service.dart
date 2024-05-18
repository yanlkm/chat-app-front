import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/room.dart';

class RoomService {
  Future<List<Room>> getRooms() async {
    const secureStorage = FlutterSecureStorage();
    String? token = await secureStorage.read(key: 'token');
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    try {
      final dio = Dio();
      final response = await dio.get(
        '${baseUrl!}/rooms',
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
        return (response.data as Map<String, dynamic>)['rooms']
            .map<Room>((room) => Room.fromJson(room))
            .toList();
      } else {
        throw Exception('Failed to load rooms error');
      }
    } catch (e) {
      throw Exception('Failed to load rooms error');
    }
  }

  Future<String> addMemberToRoom(String roomId) async {
    const secureStorage = FlutterSecureStorage();
    String? token = await secureStorage.read(key: 'token');
    String? userId = await secureStorage.read(key: 'userId');
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    try {
      final dio = Dio();
      final response = await dio.put(
        '${baseUrl!}/rooms/add/$roomId',
        data: {'ID': userId},
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
      if (response.statusCode != 200) {
        throw Exception(response.data['error']);
      }else
        {
          return 'You have been added successfully to the room';
        }
    } catch (e) {
      throw Exception('Failed to add member to room');
    }
  }

  Future<String> removeMemberFromRoom(String roomId) async {
    const secureStorage = FlutterSecureStorage();
    String? token = await secureStorage.read(key: 'token');
    String? userId = await secureStorage.read(key: 'userId');
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    try {
      final dio = Dio();
      final response = await dio.put(
        '${baseUrl!}/rooms/remove/$roomId',
        data: {'ID': userId},
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
      if (response.statusCode != 200) {
        throw Exception(response.data['error']);
      }else
      {
        return 'You have been removed successfully from the room';
      }
    } catch (e) {
      throw Exception('Failed to remove member from room');
    }
  }
}
