import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/room.dart';

class RoomService {

  // get rooms from the server
  Future<List<Room>> getRooms() async {
    // load secure storage
    const secureStorage = FlutterSecureStorage();
    String? token = await secureStorage.read(key: 'token');
    // load .env file
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    try {
      final dio = Dio();
      // send a request to the server with dio
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
      // Check the response
      if (response.statusCode == 200) {
        // if the server returns room data
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

  // Add the addRoom method
  Future<String> addMemberToRoom(String roomId) async {
    // load secure storage
    const secureStorage = FlutterSecureStorage();
    String? token = await secureStorage.read(key: 'token');
    String? userId = await secureStorage.read(key: 'userId');
    // load .env file
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    // send a request to the server with dio
    try {
      final dio = Dio();
      final response = await dio.put(
        '${baseUrl!}/rooms/add/$roomId',
        // send to server the user ID of the user to add to the room
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
      // Check the response
      if (response.statusCode != 200) {
        throw Exception(response.data['error']);
      }else
        {
          // return a success message
          return 'You have been added successfully to the room';
        }
    } catch (e) {
      // return an error message
      throw Exception('Failed to add member to room');
    }
  }

  // Add the removeMemberFromRoom method
  Future<String> removeMemberFromRoom(String roomId) async {
    // load secure storage
    const secureStorage = FlutterSecureStorage();
    String? token = await secureStorage.read(key: 'token');
    String? userId = await secureStorage.read(key: 'userId');
    // load .env file
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    try {
      // Create a Dio instance
      final dio = Dio();
      // send a request to the server with dio
      final response = await dio.put(
        '${baseUrl!}/rooms/remove/$roomId',
        // send to server the user ID of the user to remove from the room
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
      // Check the response
      if (response.statusCode != 200) {
        throw Exception(response.data['error']);
      }else
      {
        // return a success message
        return 'You have been removed successfully from the room';
      }
    } catch (e) {
      throw Exception('Failed to remove member from room');
    }
  }

  // Add the getRoomCreatedByAdmin method
  Future<List<Room>> getRoomCreatedByAdmin() async {
    // load secure storage
    const secureStorage = FlutterSecureStorage();
    String? token = await secureStorage.read(key: 'token');
    String? userId = await secureStorage.read(key: 'userId');
    // load .env file
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    // send a request to the server with dio
    try {
      final dio = Dio();
      final response = await dio.get(
        '${baseUrl!}/rooms/created/$userId',
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
        // if the server returns room data
        // if room data is not null
        if (response.data["rooms"] != null){
          return (response.data as Map<String, dynamic>)['rooms']
              .map<Room>((room) => Room.fromJson(room))
              .toList();
        } else {
          return [];
        }


      } else {
        throw Exception('Failed to load rooms error');
      }
    } catch (e) {
      throw Exception('Failed to load rooms error');
    }
}


// add hashtag to the room
Future<String> addHashtagToRoom(String roomId, String hashtag) async {
  // load secure storage
  const secureStorage = FlutterSecureStorage();
  String? token = await secureStorage.read(key: 'token');
  // load .env file
  await dotenv.load(fileName: ".env");
  String? baseUrl = dotenv.env['BASE_URL'];
  // send a request to the server with dio
  try {
    final dio = Dio();
    final response = await dio.patch(
      '${baseUrl!}/rooms/add/hashtag/$roomId',
      // send to server the hashtag to add to the room
      data: {'hashtag': hashtag},
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
    if (response.statusCode != 200) {
      throw Exception(response.data['error']);
    } else {
      // return a success message
      return 'Hashtag added successfully';
    }
  } catch (e) {
    // return an error message
    throw Exception('Failed to add hashtag to room');
  }
}

// remove hashtag from the room
Future<String> removeHashtagFromRoom(String roomId, String hashtag) async {
  // load secure storage
  const secureStorage = FlutterSecureStorage();
  String? token = await secureStorage.read(key: 'token');
  // load .env file
  await dotenv.load(fileName: ".env");
  String? baseUrl = dotenv.env['BASE_URL'];
  // send a request to the server with dio
  try {
    final dio = Dio();
    final response = await dio.patch(
      '${baseUrl!}/rooms/remove/hashtag/$roomId',
      // send to server the hashtag to remove from the room
      data: {'hashtag': hashtag},
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
    if (response.statusCode != 200) {
      throw Exception(response.data['error']);
    } else {
      // return a success message
      return 'Hashtag removed successfully';
    }
  } catch (e) {
    // return an error message
    throw Exception('Failed to remove hashtag from room');
  }
}

// Add the addRoom method
Future<Room> addRoom(String roomName, String roomDescription) async {
  // load secure storage
  const secureStorage = FlutterSecureStorage();
  String? token = await secureStorage.read(key: 'token');
  String? userId = await secureStorage.read(key: 'userId');
  // load .env file
  await dotenv.load(fileName: ".env");
  String? baseUrl = dotenv.env['BASE_URL'];
  // send a request to the server with dio
  try {
    final dio = Dio();
    final response = await dio.post(
      '${baseUrl!}/rooms',
      // send to server the room name and description
      data: {'name': roomName, 'description': roomDescription, 'creator': userId},
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
    if (response.statusCode != 200) {
      throw Exception(response.data['error']);
    }else
    {
      // return a success message
      return Room.fromJson(response.data['room']);
    }
  } catch (e) {
    // return an error message
    throw Exception('Failed to create room');
  }

}
}