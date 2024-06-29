import 'package:flutter/cupertino.dart';
import 'package:my_app/views/utils/error_popup.dart';
import '../../models/room.dart';
import '../../services/room/room_service.dart';

class RoomController {
  final RoomService roomService;

  RoomController({required this.roomService});

  Future<List<Room>> getRooms(BuildContext context) async {
    try {
      return await roomService.getRooms();
    } catch (e) {
      return [];
    }
  }

  Future<String?> addMemberToRoom(BuildContext context, String roomId) async {
    try {
     String response = await roomService.addMemberToRoom(roomId);
     return response;
    } catch (e) {
      ErrorDisplayIsolate.showErrorDialog(context, 'Failed to add you to the room');
    }
    return null;
  }

  Future<String?> removeMemberFromRoom(BuildContext context, String roomId) async {
    try {
      String response = await roomService.removeMemberFromRoom(roomId);
      return response;
    } catch (e) {

      ErrorDisplayIsolate.showErrorDialog(context, 'Failed to remove you from the room');
    }
    return null;
  }
}
