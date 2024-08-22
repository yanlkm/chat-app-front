import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';
import '../../../domain/use_cases/rooms/room_usecases.dart';
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
  final RoomUsesCases roomUsesCases;
  final ValueNotifier<List<Room>> userRoomNotifier;

  RoomsCubit(
      this.roomUsesCases,
      this.userRoomNotifier
      ) : super(RoomsInitial());

  Future<void> loadRooms() async {
    emit(RoomsLoading());
    try {
      final eitherRoomsOrError = await roomUsesCases.getUserRooms();

      eitherRoomsOrError.fold(
            (error) => emit(RoomsError(_mapErrorToMessage(error))),
            (roomEntities) {
          // Convert RoomEntity to Room model if necessary
          final rooms = roomEntities.map((roomEntity) => Room(
            roomID: roomEntity.roomID,
            name: roomEntity.name,
            description: roomEntity.description,
            // Add other fields as necessary
          )).toList();

          userRoomNotifier.value = rooms;
          emit(RoomsLoaded(userRoomNotifier.value));
        },
      );
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  String _mapErrorToMessage(NetworkErrorHandler error) {
    // Implement error mapping here
    return error.message ?? 'An error occurred';
  }
}
