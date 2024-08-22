
import 'package:either_dart/either.dart';
import 'package:my_app/data/repostiories/rooms/room_repository_impl.dart';

import '../../../utils/errors/handlers/network_error_handler.dart';
import '../../entities/rooms/room_entity.dart';


class RoomUsesCases {
  final RoomRepositoryImpl roomRepositoryImpl;

  const RoomUsesCases({
    required this.roomRepositoryImpl,
  });

  Future<Either<NetworkErrorHandler, List<RoomEntity>>> getRooms() async {
    return roomRepositoryImpl.getRooms();
  }

  Future<Either<NetworkErrorHandler, List<RoomEntity>>> getUserRooms() async {
    return roomRepositoryImpl.getUserRooms();
  }

  Future<Either<NetworkErrorHandler, String>> addMemberToRoom(String roomId) async {
    return roomRepositoryImpl.addMemberToRoom(roomId);
  }

  Future<Either<NetworkErrorHandler, String>> removeMemberFromRoom(String roomId) async {
    return roomRepositoryImpl.removeMemberFromRoom(roomId);
  }

  Future<Either<NetworkErrorHandler, RoomEntity>> addRoom(String roomName, String roomDescription) async {
    return roomRepositoryImpl.addRoom(roomName, roomDescription);
  }

  Future<Either<NetworkErrorHandler, List<RoomEntity>>> getRoomCreatedByAdmin() async {
    return roomRepositoryImpl.getRoomCreatedByAdmin();
  }

  Future<Either<NetworkErrorHandler, String>> addHashtagToRoom(String roomId, String hashtag) async {
    return roomRepositoryImpl.addHashtagToRoom(roomId, hashtag);
  }

  Future<Either<NetworkErrorHandler, String>> removeHashtagFromRoom(String roomId, String hashtag) async {
    return roomRepositoryImpl.removeHashtagFromRoom(roomId, hashtag);
  }



}