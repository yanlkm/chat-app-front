import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../controllers/user/user_rooms_controller.dart';
import '../../../models/room.dart';

abstract class RoomsState {}

class RoomsInitial extends RoomsState {
  RoomsInitial();
}

class RoomsLoading extends RoomsState {
  RoomsLoading();
}

class RoomsLoaded extends RoomsState {
  final List<Room> rooms;

  RoomsLoaded(this.rooms);
}

class RoomsError extends RoomsState {
  final String message;

  RoomsError(this.message);
}

class RoomsCubit extends Cubit<RoomsState> {
  final UserRoomsController userRoomsController;
  final ValueNotifier<List<Room>> roomsNotifier;

  RoomsCubit(
      this.userRoomsController,
      this.roomsNotifier
      ) : super(RoomsInitial());

  Future<void> loadRooms() async {
    emit(RoomsLoading());
    try {
      final rooms = await userRoomsController.getUserRooms();
      roomsNotifier.value = rooms as List<Room>;
      emit(RoomsLoaded(roomsNotifier.value));
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
    emit(RoomsLoaded(roomsNotifier.value));
  }
}