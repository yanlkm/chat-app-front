

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controllers/room/room_controller.dart';
import '../../../models/room.dart';

abstract class RoomState {}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomLoaded extends RoomState {
  final List<Room> rooms;

  final String message;

  RoomLoaded(this.rooms, this.message);
}

class RoomError extends RoomState {
  final String message;

  RoomError(this.message);
}

class RoomCubit extends Cubit<RoomState> {
  final RoomController roomController;
  final ValueNotifier<List<Room>> adminRoomNotifier;
  final ValueNotifier<List<Room>> roomsNotifier;

  RoomCubit(this.roomController, this.adminRoomNotifier, this.roomsNotifier) : super(RoomInitial());

  void loadRooms() async {
    try {
      List<Room> rooms = await roomController.getRoomCreatedByAdmin();

      if (rooms.isEmpty) {
        emit(RoomError('No rooms found'));
        return;
      }
      adminRoomNotifier.value = rooms;
      emit(RoomLoaded(adminRoomNotifier.value, 'Rooms loaded successfully'));

    } catch (e) {
      emit(RoomError(e.toString()));

    }
  }

  Future<void> createRoom(String name, String description) async {
    try {
      Room? newRoom = await roomController.createRoom(name, description);
      if (newRoom != null) {
        adminRoomNotifier.value = [...adminRoomNotifier.value, newRoom];
        roomsNotifier.value = [...roomsNotifier.value, newRoom];
        emit(RoomLoaded(adminRoomNotifier.value, 'Room created successfully'));
      } else {
        emit(RoomError('Failed to create room'));
      }
    } catch (e) {
      // Handle the error
      emit(RoomError('Failed to create room'));
    }
  }

  Future<void> addHashtagToRoom(String roomID, String hashtag) async {
    try {
     await roomController.addHashtagToRoom(roomID, hashtag);
     // find room with roomID and update the room with the new hashtag and get the index
      final room = adminRoomNotifier.value.firstWhere((room) => room.roomID == roomID);
      final index = adminRoomNotifier.value.indexOf(room);

      room.hashtags?.add(hashtag);
      // update the roomNotifier and adminRoomNotifier
      adminRoomNotifier.value[index] = room;
      roomsNotifier.value[index] = room;

    } catch (e) {
      emit(RoomError(e.toString()));
    }
  }

  Future<void> removeHashtagFromRoom(String roomID, String hashtag) async {
    try {
      await roomController.removeHashtagFromRoom(roomID, hashtag);
      // find room with roomID and update the room with the new hashtag and get the index
      final room = adminRoomNotifier.value.firstWhere((room) => room.roomID == roomID);
      final index = adminRoomNotifier.value.indexOf(room);

      room.hashtags?.remove(hashtag);
      // update the roomNotifier and adminRoomNotifier
      adminRoomNotifier.value[index] = room;
      roomsNotifier.value[index] = room;

    } catch (e) {
      emit(RoomError(e.toString()));
    }
  }


}
