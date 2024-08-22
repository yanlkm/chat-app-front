import 'package:either_dart/either.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import 'package:my_app/domain/repositories/rooms/room_repository.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';
import '../../data_sources/rooms/rooms_data_source_impl.dart';
import '../../models/rooms/room_model.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomsDataSourceImpl roomRemoteDataSource;

  RoomRepositoryImpl({
    required this.roomRemoteDataSource,
  });

  @override
  Future<Either<NetworkErrorHandler, List<RoomEntity>>> getRooms() async {
    try {
      final List<RoomModel> rooms = await roomRemoteDataSource.getRooms();
      final List<RoomEntity> roomEntities = rooms.map((room) => room.toEntity()).toList();
      return Right<NetworkErrorHandler, List<RoomEntity>>(roomEntities);
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, List<RoomEntity>>(e);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, String>> addHashtagToRoom(String roomId, String hashtag) async {
    try {
      final String response = await roomRemoteDataSource.addHashtagToRoom(roomId, hashtag);
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, String>(e);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, String>> addMemberToRoom(String roomId) async {
    try {
      final String response = await roomRemoteDataSource.addMemberToRoom(roomId);
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, String>(e);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, RoomEntity>> addRoom(String roomName, String roomDescription) async {
    try {
      final RoomModel room = await roomRemoteDataSource.addRoom(roomName, roomDescription);
      return Right<NetworkErrorHandler, RoomEntity>(room.toEntity());
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, RoomEntity>(e);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, List<RoomEntity>>> getRoomCreatedByAdmin() async {
    try {
      final List<RoomModel> rooms = await roomRemoteDataSource.getRoomCreatedByAdmin();
      final List<RoomEntity> roomEntities = rooms.map((room) => room.toEntity()).toList();
      return Right<NetworkErrorHandler, List<RoomEntity>>(roomEntities);
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, List<RoomEntity>>(e);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, List<RoomEntity>>> getUserRooms() async {
    try {
      final List<RoomModel> rooms = await roomRemoteDataSource.getUserRooms();
      final List<RoomEntity> roomEntities = rooms.map((room) => room.toEntity()).toList();
      return Right<NetworkErrorHandler, List<RoomEntity>>(roomEntities);
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, List<RoomEntity>>(e);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, String>> removeHashtagFromRoom(String roomId, String hashtag) async {
    try {
      final String response = await roomRemoteDataSource.removeHashtagFromRoom(roomId, hashtag);
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, String>(e);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, String>> removeMemberFromRoom(String roomId) async {
    try {
      final String response = await roomRemoteDataSource.removeMemberFromRoom(roomId);
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, String>(e);
    }
  }
}
