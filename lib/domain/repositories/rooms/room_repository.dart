
import 'package:either_dart/either.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';

import '../../../utils/errors/handlers/network_error_handler.dart';
// Room Repository
abstract class RoomRepository {

  Future<Either<NetworkErrorHandler,List<RoomEntity>>> getRooms();

  Future<Either<NetworkErrorHandler,List<RoomEntity>>> getUserRooms();

  Future<Either<NetworkErrorHandler,String>> addMemberToRoom(String roomId);

  Future<Either<NetworkErrorHandler,String>> removeMemberFromRoom(String roomId);

  Future<Either<NetworkErrorHandler,RoomEntity>> addRoom(String roomName, String roomDescription);

  Future<Either<NetworkErrorHandler,List<RoomEntity>>> getRoomCreatedByAdmin();

  Future<Either<NetworkErrorHandler,String>> addHashtagToRoom(String roomId, String hashtag);

  Future<Either<NetworkErrorHandler,String>> removeHashtagFromRoom(String roomId, String hashtag);

}