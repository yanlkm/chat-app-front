import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import 'package:my_app/domain/use_cases/rooms/room_usecases.dart';


abstract class RoomsState {
  RoomsState();
}

class RoomsInitial extends RoomsState {
  RoomsInitial();
}

class RoomsLoading extends RoomsState {
  RoomsLoading();
}

class RoomsLoaded extends RoomsState {
  final List<RoomEntity> rooms;
  final String message;
  RoomsLoaded(this.rooms, this.message);
}

class RoomsError extends RoomsState {
  final String message;
  RoomsError(this.message);
}

class RoomsCubit extends Cubit<RoomsState> {
  final RoomUsesCases  roomUsesCases;
  final ValueNotifier<List<RoomEntity>> roomsNotifier;
  final ValueNotifier<List<RoomEntity>> userRoomsNotifier;

  RoomsCubit(
      this.roomUsesCases,
      this.roomsNotifier,
      this.userRoomsNotifier,
      ) : super(RoomsInitial());

  Future<void> loadRooms(BuildContext context) async {
    emit(RoomsLoading());
    try {

      final eitherRoomsOrError = await roomUsesCases.getRooms();
      eitherRoomsOrError.fold(
            (error) => emit(RoomsError(error.message)),
            (rooms) {
          if (rooms.isEmpty) {
            emit(RoomsError('No rooms found'));
            return;
          }
          roomsNotifier.value = rooms;
          emit(RoomsLoaded(roomsNotifier.value, 'Rooms loaded successfully'));
        },
      );
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  Future<void> addMemberToRoom(BuildContext context, String roomID) async {
    try {
      List<RoomEntity> roomsLoaded = [];
      final eitherSuccessOrError = await roomUsesCases.addMemberToRoom(roomID);

      eitherSuccessOrError.fold(
            (error) => emit(RoomsError(error.message)),
            (success) async {
          if (success.isEmpty) {
            emit(RoomsError('Failed to add member to room'));
            return;
          }
          // refresh rooms
          final eitherRoomsOrError = await roomUsesCases.getRooms();

          eitherRoomsOrError.fold(
                (error) => emit(RoomsError(error.message)),
                (rooms) {
              if (rooms.isEmpty) {
                emit(RoomsError('No rooms found'));
                return;
              }
              roomsLoaded = rooms;
            },
          );
          // find the room and add it to userRoomsNotifier
          final room = roomsLoaded.firstWhere((room) => room.roomID == roomID);
          // Update user-specific rooms
          userRoomsNotifier.value = [...userRoomsNotifier.value, room];
          roomsNotifier.value = roomsLoaded;
          emit(RoomsLoaded(roomsNotifier.value, 'Member added and rooms updated successfully'));
        },
      );
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  Future<void> removeMemberFromRoom(BuildContext context, String roomID) async {
    try {
      List<RoomEntity> roomsLoaded = [];
      final eitherSuccessOrError = await roomUsesCases.removeMemberFromRoom(roomID);
      eitherSuccessOrError.fold(
            (error) => emit(RoomsError(error.message)),
            (success) async {
          if (success.isEmpty) {
            emit(RoomsError('Failed to remove member from room'));
            return;
          }
          // refresh rooms
          final eitherRoomsOrError = await roomUsesCases.getRooms();
          eitherRoomsOrError.fold(
                (error) => emit(RoomsError(error.message)),
                (rooms) {
              if (rooms.isEmpty) {
                emit(RoomsError('No rooms found'));
                return;
              }
              roomsLoaded = rooms;
            },
          );
          // find the room and remove it from userRoomsNotifier
          final room = roomsLoaded.firstWhere((room) => room.roomID == roomID);
          // Update user-specific rooms
          userRoomsNotifier.value = userRoomsNotifier.value.where((element) => element.roomID != roomID).toList();
          roomsNotifier.value = roomsLoaded;
          emit(RoomsLoaded(roomsNotifier.value, 'Member removed and rooms updated successfully'));
        },
      );
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  Future<void> refreshRoom(BuildContext context, int index, RoomEntity updatedRoom) async {
    try {
      final eitherRoomsOrError = await roomUsesCases.getRooms();
      eitherRoomsOrError.fold(
            (error) => emit(RoomsError(error.message)),
            (rooms) {
          if (rooms.isEmpty) {
            emit(RoomsError('No rooms found'));
            return;
          }
          roomsNotifier.value = rooms;
          emit(RoomsLoaded(roomsNotifier.value, 'Rooms loaded successfully'));
        },
      );
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  void updateRoom(RoomEntity updatedRoom) {
    final int index = roomsNotifier.value.indexWhere((room) => room.roomID == updatedRoom.roomID);
    if (index != -1) {
      roomsNotifier.value[index] = updatedRoom;
    } else {
      roomsNotifier.value = [...roomsNotifier.value, updatedRoom];
    }

    // Update userRoomsNotifier
    final int userIndex = userRoomsNotifier.value.indexWhere((room) => room.roomID == updatedRoom.roomID);
    if (userIndex != -1) {
      userRoomsNotifier.value[userIndex] = updatedRoom;
    } else {
      userRoomsNotifier.value = [...userRoomsNotifier.value, updatedRoom];
    }

    emit(RoomsLoaded(roomsNotifier.value, 'Room updated successfully'));
  }
}
