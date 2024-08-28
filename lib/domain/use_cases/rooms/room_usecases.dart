
import 'package:either_dart/either.dart';
import 'package:my_app/data/repositories/rooms/room_repository_impl.dart';

import '../../../utils/errors/handlers/network_error_handler.dart';
import '../../entities/rooms/room_entity.dart';


// Room Use Cases
class RoomUsesCases {
  final RoomRepositoryImpl roomRepositoryImpl;

  // Constructor
  const RoomUsesCases({
    required this.roomRepositoryImpl,
  });

  // Get Rooms
  Future<Either<NetworkErrorHandler, List<RoomEntity>>> getRooms() async {
    return roomRepositoryImpl.getRooms();
  }

  // Get User Rooms
  Future<Either<NetworkErrorHandler, List<RoomEntity>>> getUserRooms() async {
    return roomRepositoryImpl.getUserRooms();
  }

  // Add Member To Room
  Future<Either<NetworkErrorHandler, String>> addMemberToRoom(String roomId) async {
    return roomRepositoryImpl.addMemberToRoom(roomId);
  }

  // Remove Member From Room
  Future<Either<NetworkErrorHandler, String>> removeMemberFromRoom(String roomId) async {
    return roomRepositoryImpl.removeMemberFromRoom(roomId);
  }

  // Add Room
  Future<Either<NetworkErrorHandler, RoomEntity>> addRoom(String roomName, String roomDescription) async {
    return roomRepositoryImpl.addRoom(roomName, roomDescription);
  }

  // Get Room Created By Admin
  Future<Either<NetworkErrorHandler, List<RoomEntity>>> getRoomCreatedByAdmin() async {
    return roomRepositoryImpl.getRoomCreatedByAdmin();
  }

  // Add Hashtag To Room
  Future<Either<NetworkErrorHandler, String>> addHashtagToRoom(String roomId, String hashtag) async {
    return roomRepositoryImpl.addHashtagToRoom(roomId, hashtag);
  }

  // Remove Hashtag From Room

  Future<Either<NetworkErrorHandler, String>> removeHashtagFromRoom(String roomId, String hashtag) async {
    return roomRepositoryImpl.removeHashtagFromRoom(roomId, hashtag);
  }



}