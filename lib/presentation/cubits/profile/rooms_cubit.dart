import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';
import '../../../domain/use_cases/rooms/room_usecases.dart';

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

  RoomsLoaded(this.rooms);
}

class RoomsError extends RoomsState {
  final String message;

  RoomsError(this.message);
}

class RoomsCubit extends Cubit<RoomsState> {
  final RoomUsesCases roomUsesCases;
  final ValueNotifier<List<RoomEntity>> userRoomNotifier;

  RoomsCubit(
      this.roomUsesCases,
      this.userRoomNotifier
      ) : super(RoomsInitial());

  Future<void> loadRooms() async {
    try {
      final eitherRoomsOrError = await roomUsesCases.getUserRooms();

      eitherRoomsOrError.fold(

            (error) =>
            {
              print("Error: ${error.message}"),
              emit(RoomsError(_mapErrorToMessage(error)))

            },
            (roomEntities) {
          userRoomNotifier.value = roomEntities;
          emit(RoomsLoaded(userRoomNotifier.value));
        },
      );
    } catch (e) {
      print("Error: $e");
      emit(RoomsError(e.toString()));
    }
  }

  String _mapErrorToMessage(NetworkErrorHandler error) {
    // Implement error mapping here
    return error.message;
  }
}
