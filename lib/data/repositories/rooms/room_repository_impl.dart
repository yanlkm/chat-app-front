import 'package:either_dart/either.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import 'package:my_app/domain/repositories/rooms/room_repository.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';
import '../../data_sources/rooms/rooms_data_source_impl.dart';
import '../../models/rooms/room_model.dart';

// Room Repository Implementation
class RoomRepositoryImpl implements RoomRepository {
  // Room Remote Data Source
  final RoomsDataSourceImpl roomRemoteDataSource;

  // Constructor
  RoomRepositoryImpl({
    required this.roomRemoteDataSource,
  });

  // Get Rooms implementation : Future<Either<NetworkErrorHandler, List<RoomEntity>>
  @override
  Future<Either<NetworkErrorHandler, List<RoomEntity>>> getRooms() async {
    try {
      // Get rooms
      final List<RoomModel> rooms = await roomRemoteDataSource.getRooms();
      // Map rooms to entities
      final List<RoomEntity> roomEntities = rooms.map((room) => room.toEntity()).toList();
      // Return rooms entities
      return Right<NetworkErrorHandler, List<RoomEntity>>(roomEntities);
    } on NetworkErrorHandler catch (e) {
      // Catch error if any error occurs
      return Left<NetworkErrorHandler, List<RoomEntity>>(e);
    }
  }

  // Add Hashtag To Room implementation : Future<Either<NetworkErrorHandler, String>>
  @override
  Future<Either<NetworkErrorHandler, String>> addHashtagToRoom(String roomId, String hashtag) async {
    try {
      // Add hashtag to room
      final String response = await roomRemoteDataSource.addHashtagToRoom(roomId, hashtag);
      // Return response if successful
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      // Catch error if any error occurs
      return Left<NetworkErrorHandler, String>(e);
    }
  }

  // Add Member To Room implementation : Future<Either<NetworkErrorHandler, String>>
  @override
  Future<Either<NetworkErrorHandler, String>> addMemberToRoom(String roomId) async {
    try {
      // Add member to room
      final String response = await roomRemoteDataSource.addMemberToRoom(roomId);
      // Return response if successful
      return Right<NetworkErrorHandler, String>(response);
      // Catch error if any error occurs
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, String>(e);
    }
  }

  // Add Room implementation : Future<Either<NetworkErrorHandler, RoomEntity>>
  @override
  Future<Either<NetworkErrorHandler, RoomEntity>> addRoom(String roomName, String roomDescription) async {
    // Add room
    try {
      // Add room and return room entity
      final RoomModel room = await roomRemoteDataSource.addRoom(roomName, roomDescription);
      return Right<NetworkErrorHandler, RoomEntity>(room.toEntity());
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, RoomEntity>(e);
    }
  }

  // Get Room Created By Admin implementation : Future<Either<NetworkErrorHandler, List<RoomEntity>>
  @override
  Future<Either<NetworkErrorHandler, List<RoomEntity>>> getRoomCreatedByAdmin() async {
    try {
      // Get rooms created by admin
      final List<RoomModel> rooms = await roomRemoteDataSource.getRoomCreatedByAdmin();
      // Map rooms to entities
      final List<RoomEntity> roomEntities = rooms.map((room) => room.toEntity()).toList();
      // Return rooms entities
      return Right<NetworkErrorHandler, List<RoomEntity>>(roomEntities);
    } on NetworkErrorHandler catch (e) {
      // Catch error if any error occurs
      return Left<NetworkErrorHandler, List<RoomEntity>>(e);
    }
  }

  // Get User Rooms implementation : Future<Either<NetworkErrorHandler, List<RoomEntity>>
  @override
  Future<Either<NetworkErrorHandler, List<RoomEntity>>> getUserRooms() async {
    try {
      final List<RoomModel> rooms = await roomRemoteDataSource.getUserRooms();
      // Map rooms to entities
      final List<RoomEntity> roomEntities = rooms.map((room) => room.toEntity()).toList();
      // Return rooms entities
      return Right<NetworkErrorHandler, List<RoomEntity>>(roomEntities);
    } on NetworkErrorHandler catch (e) {
      // Catch error if any error occurs
      return Left<NetworkErrorHandler, List<RoomEntity>>(e);
    }
  }

  // Remove Hashtag From Room implementation : Future<Either<NetworkErrorHandler, String>>
  @override
  Future<Either<NetworkErrorHandler, String>> removeHashtagFromRoom(String roomId, String hashtag) async {
    try {
      // Remove hashtag from room
      final String response = await roomRemoteDataSource.removeHashtagFromRoom(roomId, hashtag);
      // Return response if successful
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      // Catch error if any error occurs
      return Left<NetworkErrorHandler, String>(e);
    }
  }

  // Remove Member From Room implementation : Future<Either<NetworkErrorHandler, String>>
  @override
  Future<Either<NetworkErrorHandler, String>> removeMemberFromRoom(String roomId) async {
    try {
      // Remove member from room
      final String response = await roomRemoteDataSource.removeMemberFromRoom(roomId);
      // Return response if successful
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, String>(e);
    }
  }
}
