import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/use_cases/chat/db/message_db_usecases.dart';
import 'package:my_app/domain/use_cases/chat/socket/message_socket_usescases.dart';
import '../../../domain/entities/rooms/room_entity.dart';
import '../../../domain/use_cases/authentication/auth_usecases.dart';
import '../../../domain/use_cases/rooms/room_usecases.dart';
import '../../../domain/use_cases/users/user_usecases.dart';
import '../../cubits/rooms/rooms_cubit.dart';
import '../../views/rooms/rooms_view.dart';


// RoomPage : room page entry point
class RoomPage extends StatelessWidget {
  // useCases
  final AuthUseCases authUseCases;
  final RoomUsesCases roomUseCases;
  final UserUseCases userUseCases;
  final MessageDBUseCases messageDBUseCases;
  final MessageSocketUseCases messageSocketUseCases;

  // notifiers
  final ValueNotifier<List<RoomEntity>> roomsNotifier;
  final ValueNotifier<List<RoomEntity>> userRoomsNotifier;

  // Constructor
  const RoomPage({
    super.key,
    required this.authUseCases,
    required this.roomUseCases,
    required this.userUseCases,
    required this.messageDBUseCases,
    required this.messageSocketUseCases,
    required this.roomsNotifier,
    required this.userRoomsNotifier,
  });

  // build method : build the widget
  @override
  Widget build(BuildContext context) {
    // BlocProvider : provider for the bloc in the widget tree
    return BlocProvider(
      create: (context) => RoomsCubit(
        roomUseCases,
        roomsNotifier,
        userRoomsNotifier,
      )..loadRooms(context),
      child: RoomView(
        authUseCases: authUseCases,
        roomsNotifier: roomsNotifier,
        messageDBUseCases: messageDBUseCases,
        messageSocketUseCases: messageSocketUseCases,
      ),
    );
  }
}