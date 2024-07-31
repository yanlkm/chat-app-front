import 'package:flutter/material.dart';
import 'package:my_app/controllers/authentification/logout_controller.dart';
import 'package:my_app/presentation/views/profile/profile_view.dart';
import 'package:my_app/views/room/room_page.dart';
import 'package:my_app/views/admin/admin_page.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../controllers/user/user_rooms_controller.dart';
import '../../../models/room.dart';
import '../../../models/user.dart';




class PageContent extends StatelessWidget {
  final int selectedIndex;
  final bool isAdmin;
  final RoomPage roomPage;
  final AdminPage adminPage;
  final UserController userController;
  final UserRoomsController userRoomsController;
  final LogoutController logoutController;
  late ValueNotifier<List<Room>> roomsNotifier;
  late ValueNotifier<List<User>> usersNotifier;

    PageContent({
    super.key,
    required this.selectedIndex,
    required this.isAdmin,
    required this.roomPage,
    required this.adminPage,
    required this.userController,
    required this.userRoomsController,
    required this.logoutController,
    required this.roomsNotifier,
    required this.usersNotifier,
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
          roomsNotifier: roomsNotifier,
      ),
        roomPage,
        if (isAdmin)
          adminPage,
      ],
    );
  }
}
