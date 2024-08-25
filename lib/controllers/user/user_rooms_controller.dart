import 'package:flutter/foundation.dart';

import '../../models/room.dart';
import '../../services/user/user_rooms_service.dart';

class UserRoomsController {
  final UserRoomsService userRoomsService;

  // Constructor
  UserRoomsController({required this.userRoomsService});

  // Get user rooms
  Future<List<Room?>?> getUserRooms() async {
    try {
      // Call the get user rooms service
      return await userRoomsService.getUserRooms();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load user rooms: $e');
      }
      // Display error message

    }
    // Return null if an error occurred
    return null;
  }
}