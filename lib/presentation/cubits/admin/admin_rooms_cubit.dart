import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import 'package:my_app/domain/use_cases/rooms/room_usecases.dart';

abstract class RoomState {
  RoomState();
}

class RoomInitial extends RoomState {
  RoomInitial();
}

class RoomLoading extends RoomState {
  RoomLoading();
}

class RoomLoaded extends RoomState {
  final List<RoomEntity> rooms;

  final String message;
  final bool hasError;

  RoomLoaded(this.rooms, this.message, this.hasError);
}

class RoomError extends RoomState {
  final String message;

  RoomError(this.message);
}

class RoomCubit extends Cubit<RoomState> {
  final RoomUsesCases roomUsesCases;
  final ValueNotifier<List<RoomEntity>> adminRoomNotifier;
  final ValueNotifier<List<RoomEntity>> roomsNotifier;

  RoomCubit(this.roomUsesCases, this.roomsNotifier,  this.adminRoomNotifier,)
      : super(RoomInitial());

  void loadRooms() async {
    try {
      final eitherRoomsOrError = await roomUsesCases.getRoomCreatedByAdmin();
      eitherRoomsOrError.fold((error) =>
          {
          emit(RoomError(error.message)),
          },
          (rooms) {
        if (rooms.isEmpty) {
          emit(RoomError('No rooms found'));
          return;
        }
        adminRoomNotifier.value = rooms;
        emit(RoomLoaded(adminRoomNotifier.value, 'Rooms loaded successfully', false));
      });
    } catch (e) {
      emit(RoomError(e.toString()));
    }
  }

  Future<void> createRoom(String name, String description) async {
    try {
      // if state is RoomLoading return
      if (state is RoomLoading) {
        return;
      }
      final eitherRoomOrError = await roomUsesCases.addRoom(name, description);
      eitherRoomOrError.fold(
              (error) =>
              {
                emit(RoomLoaded(adminRoomNotifier.value, error.message, true)),
              }, (room) {
        final newRoom = RoomEntity(
          roomID: room.roomID,
          name: room.name,
          description: room.description,
          hashtags: room.hashtags,
        );

        adminRoomNotifier.value = [...adminRoomNotifier.value, newRoom];
        roomsNotifier.value = [...roomsNotifier.value, newRoom];
        emit(RoomLoaded(adminRoomNotifier.value, 'Room created successfully', false));
      });
    } catch (e) {
      // Handle the error
      emit(RoomError('Failed to create room'));
    }
  }

  Future<void> addHashtagToRoom(String roomID, String hashtag) async {
    try {
      final eitherSuccessOrError =
          await roomUsesCases.addHashtagToRoom(roomID, hashtag);
      eitherSuccessOrError.fold((error) => emit(RoomError(error.message)),
          (success) async {
        if (success.isEmpty) {
          emit(RoomError('Failed to add hashtag to room'));
          return;
        }
        // find room with roomID and update the room with the new hashtag and get the index
        final room =
            adminRoomNotifier.value.firstWhere((room) => room.roomID == roomID);

        final indexAdmin = findRoomIndex(adminRoomNotifier.value, roomID);
        final indexRooms = findRoomIndex(roomsNotifier.value, roomID);
        if (indexAdmin == -1 || indexRooms == -1) {
          emit(RoomError('Room not found'));
          return;
        }

        room.hashtags?.add(hashtag);
        // update the roomNotifier and adminRoomNotifier
        adminRoomNotifier.value[indexAdmin] = room;
        roomsNotifier.value[indexRooms] = room;
        emit(RoomLoaded(
            adminRoomNotifier.value, 'Hashtag added to room successfully', false));
      });
    } catch (e) {
      emit(RoomError(e.toString()));
    }
  }

  Future<void> removeHashtagFromRoom(String roomID, String hashtag) async {
    try {
      final eitherSuccessOrError =
          await roomUsesCases.removeHashtagFromRoom(roomID, hashtag);
      eitherSuccessOrError.fold((error) => emit(RoomError(error.message)),
          (success) async {
        if (success.isEmpty) {
          emit(RoomError('Failed to remove hashtag from room'));
          return;
        }
        // find room with roomID and update the room with the new hashtag and get the index
        final room = adminRoomNotifier.value.firstWhere((room) => room.roomID == roomID);


        final indexAdmin = findRoomIndex(adminRoomNotifier.value, roomID);
        final indexRooms = findRoomIndex(roomsNotifier.value, roomID);
        if (indexAdmin == -1 || indexRooms == -1) {
          emit(RoomError('Room not found'));
          return;
        }
        room.hashtags?.remove(hashtag);
        // update the roomNotifier and adminRoomNotifier
        adminRoomNotifier.value[indexAdmin] = room;
        roomsNotifier.value[indexRooms] = room;
        emit(RoomLoaded(
            adminRoomNotifier.value, 'Hashtag removed from room successfully', false));
      });
    } catch (e) {
      emit(RoomError(e.toString()));
    }
  }
  int findRoomIndex(List<RoomEntity> rooms, String roomID) {
    for (int i = 0; i < rooms.length; i++) {
      if (rooms[i].roomID == roomID) {
        return i; // Return the index if the roomID matches
      }
    }
    return -1; // Return -1 if the roomID is not found
  }

}
