import 'package:flutter/material.dart';
import 'package:my_app/controllers/user/user_controller.dart';
import 'package:my_app/controllers/room/room_controller.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/models/room.dart';
import '../../controllers/authentification/logout_controller.dart';
import 'admin_page_state.dart';

class AdminPage extends StatefulWidget {
  final UserController userController;
  final RoomController roomController;
  final ValueNotifier<List<User>> usersNotifier;
  final ValueNotifier<List<Room>> roomsNotifier = ValueNotifier<List<Room>>([]);
  final void Function(Room) updateOneRoomCallback;
  final LogoutController logoutController;

   AdminPage({
    super.key,
    required this.userController,
    required this.roomController,
    required this.updateOneRoomCallback,
    required this.usersNotifier,
    required this.logoutController,
  });

  @override
  AdminPageState createState() => AdminPageState();
}
