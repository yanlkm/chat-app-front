import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/data/data_sources/rooms/rooms_data_source.dart';
import 'package:my_app/data/models/rooms/room_model.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/options_data.dart';
import '../../../utils/data/dio_data.dart';
import '../../../utils/errors/handlers/network_error_handler.dart';

// This class is the implementation of the RoomsDataSource
class RoomsDataSourceImpl implements RoomsDataSource {
  // Instances of the required classes
  final DioData dioData;
  final FlutterSecureStorage secureStorage;
  final OptionsData optionsData;
  final AppConstants appConstants;

  // constructor
  RoomsDataSourceImpl({
    required this.dioData,
    required this.secureStorage,
    required this.optionsData,
    required this.appConstants,
  });

  // This method is used to get all rooms
  @override
  Future<List<RoomModel>> getRooms() async {
    final options = await optionsData.loadOptions();
    try {
      // Get the rooms
      final response = await dioData.get(
        '/rooms',
        options: options,
      );
      // Check if the response status code is 200
      if (response.statusCode == 200) {
        final List<dynamic> roomsData = response.data['rooms'];
        return roomsData.map((room) => RoomModel.fromJson(room)).toList();
      } else {
        // Throw an error if the response status code is not 200
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } catch (e) {
     rethrow;
    }
  }

  // This method is used to add a hashtag to a room
  @override
  Future<String> addHashtagToRoom(String roomId, String hashtag) async {
    final options = await optionsData.loadOptions();
    try {
      // Add the hashtag to the room request to the server
      final response = await dioData.patch(
        '/rooms/add/hashtag/$roomId',
        data: {'hashtag': hashtag},
        options: options
      );
      // Check if the response status code is 200
      if (response.statusCode == 200) {
        return 'Hashtag added successfully';
      } else {
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // This method is used to add a member to a room
  @override
  Future<String> addMemberToRoom(String roomId) async {
    final options = await optionsData.loadOptions();
    final String? userId = await secureStorage.read(key: 'userId');
    // Add the member to the room request to the server
    try {
      final response = await dioData.put(
        '/rooms/add/$roomId',
        data: {'ID': userId},
        options: options,
      );
      // Check if the response status code is 200
      if (response.statusCode == 200) {
        return 'Member added successfully';
      } else {
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // This method is used to add a new room
  @override
  Future<RoomModel> addRoom(String roomName, String roomDescription) async {
    final String? userId = await secureStorage.read(key: 'userId');
    final options = await optionsData.loadOptions();
    // Add the room request to the server
    try {
      final response = await dioData.post(
        '/rooms',
        data: {
          'name': roomName,
          'description': roomDescription,
          'creator': userId,
        },
        options: options
      );
      // Check if the response status code is 200
      if (response.statusCode == 200) {
        return RoomModel.fromJson(response.data['room']);
      } else {
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // This method is used to get the rooms created by the admin currently logged in
  @override
  Future<List<RoomModel>> getRoomCreatedByAdmin() async {
    final String? userId = await secureStorage.read(key: 'userId');
    final options = await optionsData.loadOptions();
    try {
      // Get the rooms created by the admin request to the server
      final response = await dioData.get(
        '/rooms/created/$userId',
        options: options
      );
      if (response.statusCode == 200) {
        final List<dynamic> roomsData = response.data['rooms'] ?? [];
        return roomsData.map((room) => RoomModel.fromJson(room)).toList();
      } else {
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // This method is used to get rooms that user is a member of
  @override
  Future<List<RoomModel>> getUserRooms() async {
    final options = await optionsData.loadOptions();
    final String? userId = await secureStorage.read(key: 'userId');
    try {
      final response = await dioData.get(
        '/rooms/user/$userId',
        options: options
      );
      // If the response status code is 200
      if (response.statusCode == 200) {
        final List<dynamic> roomsData = response.data['rooms'] ?? [];
        return roomsData.map((room) => RoomModel.fromJson(room)).toList();
      } else {
        // Throw an error if the response status code is not 200
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } catch (e) {
      rethrow;
      }
  }

  // This method is used to remove a hashtag from a room
  @override
  Future<String> removeHashtagFromRoom(String roomId, String hashtag) async {
    final options = await optionsData.loadOptions();
    try {
      // Remove the hashtag from the room request to the server
      final response = await dioData.patch(
        '/rooms/remove/hashtag/$roomId',
        data: {'hashtag': hashtag},
        options: options
      );
      // Check if the response status code is 200
      if (response.statusCode == 200) {
        return 'Hashtag removed successfully';
      } else {
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } catch (e) {
     rethrow;
    }
  }

  // This method is used to remove a member from a room
  @override
  Future<String> removeMemberFromRoom(String roomId) async {
    final String? userId = await secureStorage.read(key: 'userId');
    final options = await optionsData.loadOptions();
    try {
      // Remove the member from the room request to the server
      final response = await dioData.put(
        '/rooms/remove/$roomId',
        data: {'ID': userId},
        options:options,
      );
      // Check if the response status code is 200
      if (response.statusCode == 200) {
        return 'Member removed successfully';
      } else {
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
