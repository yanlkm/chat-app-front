
import '../../models/rooms/room_model.dart';

abstract class RoomsDataSource {

  // Get all rooms
  Future<List<RoomModel>> getRooms();

  // Get user rooms
  Future<List<RoomModel>> getUserRooms();

  // Add member to room
  Future<String> addMemberToRoom(String roomId);

  // Remove member from room
  Future<String> removeMemberFromRoom(String roomId);

  // Create room
  Future<RoomModel> addRoom(String roomName, String roomDescription);

  // Get rooms created by admin
  Future<List<RoomModel>> getRoomCreatedByAdmin();

  // Add hashtag to room
  Future<String> addHashtagToRoom(String roomId, String hashtag);

  // Remove hashtag from room
  Future<String> removeHashtagFromRoom(String roomId, String hashtag);

}