import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/data/data_sources/rooms/rooms_data_source.dart';
import 'package:my_app/data/models/rooms/room_model.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/options_data.dart';
import '../../../utils/data/dio_data.dart';

class RoomsDataSourceImpl implements RoomsDataSource {
  final DioData dioData;
  final FlutterSecureStorage secureStorage;
  final OptionsData optionsData;
  final AppConstants appConstants;

  RoomsDataSourceImpl({
    required this.dioData,
    required this.secureStorage,
    required this.optionsData,
    required this.appConstants,
  });

  @override
  Future<List<RoomModel>> getRooms() async {
    final options = await optionsData.loadOptions();
    try {
      final response = await dioData.get(
        '/rooms',
        options: options,
      );
      if (response.statusCode == 200) {
        final List<dynamic> roomsData = response.data['rooms'];
        return roomsData.map((room) => RoomModel.fromJson(room)).toList();
      } else {
        throw response.data['error'] ?? 'Failed to get rooms';
      }
    } catch (e) {
     rethrow;
    }
  }

  @override
  Future<String> addHashtagToRoom(String roomId, String hashtag) async {
    final options = await optionsData.loadOptions();
    try {
      final response = await dioData.patch(
        '/rooms/add/hashtag/$roomId',
        data: {'hashtag': hashtag},
        options: options
      );
      if (response.statusCode == 200) {
        return 'Hashtag added successfully';
      } else {
        throw response.data['error'] ?? 'Failed to add hashtag';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> addMemberToRoom(String roomId) async {
    final options = await optionsData.loadOptions();
    final String? userId = await secureStorage.read(key: 'userId');

    try {
      final response = await dioData.put(
        'rooms/add/$roomId',
        data: {'ID': userId},
        options: options,
      );

      if (response.statusCode == 200) {
        return 'Member added successfully';
      } else {
        throw response.data['error'] ?? 'Failed to add member';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RoomModel> addRoom(String roomName, String roomDescription) async {
    final String? userId = await secureStorage.read(key: 'userId');
    final options = await optionsData.loadOptions();


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

      if (response.statusCode == 200) {
        return RoomModel.fromJson(response.data['room']);
      } else {
        throw response.data['error'] ?? 'Failed to create room';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RoomModel>> getRoomCreatedByAdmin() async {
    final String? userId = await secureStorage.read(key: 'userId');
    final options = await optionsData.loadOptions();
    try {
      final response = await dioData.get(
        '/rooms/created/$userId',
        options: options
      );
      if (response.statusCode == 200) {
        final List<dynamic> roomsData = response.data['rooms'] ?? [];
        return roomsData.map((room) => RoomModel.fromJson(room)).toList();
      } else {
        throw response.data['error'] ?? 'Failed to get rooms created by admin';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RoomModel>> getUserRooms() async {
    final options = await optionsData.loadOptions();
    final String? userId = await secureStorage.read(key: 'userId');
    try {
      final response = await dioData.get(
        'rooms/user/$userId',
        options: options
      );
      if (response.statusCode == 200) {
        final List<dynamic> roomsData = response.data['rooms'] ?? [];
        return roomsData.map((room) => RoomModel.fromJson(room)).toList();
      } else {
        throw response.data['error'] ?? 'Failed to get user rooms';
      }
    } catch (e) {
      rethrow;
      }
  }

  @override
  Future<String> removeHashtagFromRoom(String roomId, String hashtag) async {
    final options = await optionsData.loadOptions();
    try {
      final response = await dioData.patch(
        '/rooms/remove/hashtag/$roomId',
        data: {'hashtag': hashtag},
        options: options
      );

      if (response.statusCode == 200) {
        return 'Hashtag removed successfully';
      } else {
        throw response.data['error'] ?? 'Failed to remove hashtag';
      }
    } catch (e) {
     rethrow;
    }
  }

  @override
  Future<String> removeMemberFromRoom(String roomId) async {
    final String? userId = await secureStorage.read(key: 'userId');
    final options = await optionsData.loadOptions();
    try {
      final response = await dioData.put(
        '/rooms/remove/$roomId',
        data: {'ID': userId},
        options:options,
      );

      if (response.statusCode == 200) {
        return 'Member removed successfully';
      } else {
        throw response.data['error'] ?? 'Failed to remove member';
      }
    } catch (e) {
      rethrow;
    }
  }
}
