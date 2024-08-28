import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';
import '../../../domain/use_cases/rooms/room_usecases.dart';

// RoomsState
abstract class RoomsState {
  RoomsState();
}

// RoomsInitial : initial state
class RoomsInitial extends RoomsState {
  RoomsInitial();
}

// RoomsLoading : loading state
class RoomsLoading extends RoomsState {
  RoomsLoading();
}

// RoomsLoaded : loaded state
class RoomsLoaded extends RoomsState {
  final List<RoomEntity> rooms;

  RoomsLoaded(this.rooms);
}

// RoomsError : error state
class RoomsError extends RoomsState {
  final String message;

  RoomsError(this.message);
}

// RoomsCubit : cubit for rooms
class RoomsCubit extends Cubit<RoomsState> {
  final RoomUsesCases roomUsesCases;
  final ValueNotifier<List<RoomEntity>> userRoomNotifier;

  // Constructor
  RoomsCubit(
      this.roomUsesCases,
      this.userRoomNotifier
      ) : super(RoomsInitial());

  // loadRooms method : load rooms
  Future<void> loadRooms() async {
    try {
      final eitherRoomsOrError = await roomUsesCases.getUserRooms();

      // either fold: if error emit error state, if success emit loaded state
      eitherRoomsOrError.fold(
          // if error : emit error state
            (error) =>
            {
              emit(RoomsError(_mapErrorToMessage(error)))

            },
            (roomEntities) {
              // if success : emit loaded state
          userRoomNotifier.value = roomEntities;
          emit(RoomsLoaded(userRoomNotifier.value));
        },
      );
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  // _mapErrorToMessage method : map error to message
  String _mapErrorToMessage(NetworkErrorHandler error) {
    // Implement error mapping here
    return error.message;
  }
}
