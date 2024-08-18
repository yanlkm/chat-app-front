import 'package:flutter/cupertino.dart';
import 'package:my_app/views/utils/error_popup.dart';
import '../../models/room.dart';
import '../../services/room/room_service.dart';

class RoomController {
  final RoomService roomService;

  // Constructor
  RoomController({required this.roomService});

  // Get rooms
  Future<List<Room>> getRooms(BuildContext context) async {
    try {
      return await roomService.getRooms();
    } catch (e) {
      return [];
    }
  }

  // Create room
  Future<String?> addMemberToRoom(BuildContext context, String roomId) async {
    try {
     String response = await roomService.addMemberToRoom(roomId);
     return response;
    } catch (e) {
      ErrorDisplayIsolate.showErrorDialog(context, 'Failed to add you to the room');
    }
    return null;
  }

  // Remove member from room
  Future<String?> removeMemberFromRoom(BuildContext context, String roomId) async {
    try {
      String response = await roomService.removeMemberFromRoom(roomId);
      return response;
    } catch (e) {
      // Display error message
      ErrorDisplayIsolate.showErrorDialog(context, 'Failed to remove you from the room');
    }
    return null;
  }

  // Create room
  Future<Room?> createRoom( String roomName, String roomDescription) async {
    try {
      return await roomService.addRoom(roomName, roomDescription);

    } catch (e) {
      // Display error message
     // ErrorDisplayIsolate.showErrorDialog(context, 'Failed to create the room');
      rethrow;
    }
    return null;
  }

  // getRoomCreatedByAdmin method
  Future<List<Room>> getRoomCreatedByAdmin() async {
    try {
      return await roomService.getRoomCreatedByAdmin();
    } catch (e) {
      return [];
    }
  }

  // add hashtag to room
  Future<String?> addHashtagToRoom( String roomId, String hashtag) async {
    try {
      String response = await roomService.addHashtagToRoom(roomId, hashtag);
      return response;
    } catch (e) {
      // Display error message
      //ErrorDisplayIsolate.showErrorDialog(context, 'Failed to add hashtag to the room');
      rethrow ;
    }
    return null;
  }

  // remove hashtag from room
  Future<String?> removeHashtagFromRoom( String roomId, String hashtag) async {
    try {
      String response = await roomService.removeHashtagFromRoom(roomId, hashtag);
      return response;
    } catch (e) {
      // Display error message
      //ErrorDisplayIsolate.showErrorDialog(context, 'Failed to remove hashtag from the room');
      rethrow;
    }
    return null;
  }


}
