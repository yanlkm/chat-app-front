import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/controllers/authentification/logout_controller.dart';
import 'package:my_app/controllers/room/room_controller.dart';
import 'package:my_app/controllers/user/user_rooms_controller.dart';
import 'package:my_app/models/room.dart';
import '../../cubits/rooms/rooms_cubit.dart';
import '../../views/rooms/rooms_view.dart';


class RoomPage extends StatelessWidget {
  final RoomController roomController;
  final LogoutController logoutController;
  final UserRoomsController userRoomsController;
  final ValueNotifier<List<Room>> roomsNotifier;
  final ValueNotifier<List<Room>> userRoomsNotifier;

  const RoomPage({
    super.key,
    required this.roomController,
    required this.logoutController,
    required this.userRoomsController,
    required this.roomsNotifier,
    required this.userRoomsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomsCubit(
        roomController,
        userRoomsController,
        roomsNotifier,
        userRoomsNotifier,
      )..loadRooms(context),
      child: RoomView(
        logoutController: logoutController,
        roomsNotifier: roomsNotifier,
      ),
    );
  }
}