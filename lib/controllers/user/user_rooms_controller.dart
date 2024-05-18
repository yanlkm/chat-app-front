import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:my_app/views/utils/error_popup.dart';

import '../../models/room.dart';
import '../../services/user/user_rooms_service.dart';

class UserRoomsController {
  final UserRoomsService userRoomsService;

  UserRoomsController({required this.userRoomsService});

  Future<List<Room?>?> getUserRooms(BuildContext context) async {
    try {
      return await userRoomsService.getUserRooms();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load user rooms: $e');
      }
      ErrorDisplayIsolate.showErrorSnackBar(context, 'Failed to load user rooms');
    }

    return null;
  }
}