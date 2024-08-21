import 'package:flutter/material.dart';
import 'package:my_app/controllers/authentification/logout_controller.dart';
import 'package:my_app/controllers/room/room_controller.dart';
import 'package:my_app/presentation/pages/admin/admin_page.dart';
import 'package:my_app/presentation/pages/profile/profile_page.dart';
import 'package:my_app/presentation/pages/rooms/rooms_page.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../controllers/user/user_rooms_controller.dart';
import '../../../models/room.dart';
import '../../../models/user.dart';


class PageContent extends StatelessWidget {
  final int selectedIndex;
  final bool isAdmin;
  final UserController userController;
  final RoomController roomController;
  final UserRoomsController userRoomsController;
  final LogoutController logoutController;
  late ValueNotifier<List<Room>> roomsNotifier;
  late ValueNotifier<List<User>> usersNotifier;
  late ValueNotifier<User> selectedUserNotifier;
  late ValueNotifier<User> userFoundNotifier;
  late ValueNotifier<List<Room>> userRoomsNotifier;
  late ValueNotifier<List<Room>> adminRoomNotifier;

    PageContent({
    super.key,
    required this.selectedIndex,
    required this.isAdmin,
    required this.userController,
    required this.userRoomsController,
    required this.logoutController,
    required this.roomsNotifier,
    required this.usersNotifier,
      required this.selectedUserNotifier,
      required this.userFoundNotifier,
      required this.roomController,
      required this.userRoomsNotifier,
      required this.adminRoomNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: selectedIndex,
      children: [
        ProfilePage(
        userController: userController,
        logoutController: logoutController,
        userRoomsController: userRoomsController,
          userRoomNotifier: userRoomsNotifier,
      ),
      RoomPage(
        logoutController: logoutController,
        userRoomsController: userRoomsController,
        roomsNotifier: roomsNotifier,
        roomController: roomController,
        userRoomsNotifier: userRoomsNotifier,
      ),
        if (isAdmin)
          AdminPage(
            logoutController: logoutController,
            userController: userController,
            roomController: roomController,
            adminRoomNotifier: adminRoomNotifier,
            roomsNotifier: roomsNotifier,
            userNotifier: usersNotifier,
            userFoundNotifier: userFoundNotifier,
            selectedUserNotifier: selectedUserNotifier,
          ),
      ],
    );
  }
}
