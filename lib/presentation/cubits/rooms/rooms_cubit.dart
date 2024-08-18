import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_app/controllers/user/user_rooms_controller.dart';
import 'package:my_app/models/room.dart';

import '../../../controllers/room/room_controller.dart';

abstract class RoomsState {}

class RoomsInitial extends RoomsState {}

class RoomsLoading extends RoomsState {}

class RoomsLoaded extends RoomsState {
  final List<Room> rooms;
  final String message;
  RoomsLoaded(this.rooms, this.message);
}

class RoomsError extends RoomsState {
  final String message;
  RoomsError(this.message);
}

class RoomsCubit extends Cubit<RoomsState> {
  final RoomController roomController;
  final UserRoomsController userRoomsController;
  final ValueNotifier<List<Room>> roomsNotifier;
  final ValueNotifier<List<Room>> userRoomsNotifier;

  RoomsCubit(
      this.roomController,
      this.userRoomsController,
      this.roomsNotifier,
      this.userRoomsNotifier,
      ) : super(RoomsInitial());

  Future<void> loadRooms(BuildContext context) async {
    emit(RoomsLoading());
    try {
      final rooms = await roomController.getRooms(context);
      print('Rooms: ${rooms}');
      if (rooms.isEmpty) {
        emit(RoomsError('No rooms found'));
        return;
      }
      roomsNotifier.value = rooms;
      emit(RoomsLoaded(roomsNotifier.value, 'Rooms loaded successfully'));
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  Future<void> addMemberToRoom(BuildContext context, String roomID) async {
    try {
      final response = await roomController.addMemberToRoom(context, roomID);
      if (response == null) {
        emit(RoomsError('Failed to add member to room'));
        return;
      }
      // Update rooms
      final newRooms = await roomController.getRooms(context);
      roomsNotifier.value = newRooms;

      // Update user-specific rooms
      final userRooms = await userRoomsController.getUserRooms();
      userRoomsNotifier.value = userRooms as List<Room>;

      emit(RoomsLoaded(roomsNotifier.value, 'Member added and rooms updated successfully'));
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  Future<void> removeMemberFromRoom(BuildContext context, String roomID) async {
    try {
      final response = await roomController.removeMemberFromRoom(context, roomID);
      if (response == null) {
        emit(RoomsError('Failed to remove member from room'));
        return;
      }
      // Update rooms
      final newRooms = await roomController.getRooms(context);
      roomsNotifier.value = newRooms;

      // Update user-specific rooms
      final userRooms = await userRoomsController.getUserRooms();
      userRoomsNotifier.value = userRooms as List<Room>;

      emit(RoomsLoaded(roomsNotifier.value, 'Member removed and rooms updated successfully'));
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  Future<void> refreshRoom(BuildContext context, int index, Room updatedRoom) async {
    try {
      final newRooms = await roomController.getRooms(context);
      roomsNotifier.value = newRooms;
      emit(RoomsLoaded(roomsNotifier.value, 'Rooms loaded successfully'));
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  void updateRoom(Room updatedRoom) {
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
