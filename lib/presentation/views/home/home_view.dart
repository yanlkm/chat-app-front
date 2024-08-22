import 'package:flutter/material.dart';

import '../../../controllers/authentification/logout_controller.dart';
import '../../../controllers/room/room_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../controllers/user/user_rooms_controller.dart';
import '../../../domain/use_cases/rooms/room_usecases.dart';
import '../../../domain/use_cases/users/user_usecases.dart';
import '../../../models/room.dart';
import '../../../models/user.dart';
import '../../_widgets/home/bottom_navigation_widget.dart';
import '../../_widgets/home/page_content.dart';

class HomeView extends StatelessWidget {
  final int selectedIndex;
  final bool isAdmin;
  final Function(int) onItemTapped;

  final UserController userController;
  final RoomController roomController;
  final LogoutController logoutController;
  final UserRoomsController userRoomsController;

  // usesCases
  final UserUseCases userUseCases;
  // roomUseCases
  final RoomUsesCases roomUsesCases;

  final ValueNotifier<List<Room>> roomsNotifier;
  final ValueNotifier<List<User>> usersNotifier;
  final ValueNotifier<List<Room>> userRoomsNotifier;
  final ValueNotifier<User> selectedUserNotifier;
  final ValueNotifier<User> userFoundNotifier;
  final ValueNotifier<List<Room>> adminRoomNotifier;

  const HomeView({
    Key? key,
    required this.selectedIndex,
    required this.isAdmin,
    required this.onItemTapped,
    required this.userController,
    required this.roomController,
    required this.logoutController,
    required this.userRoomsController,
    required this.roomsNotifier,
    required this.usersNotifier,
    required this.selectedUserNotifier,
    required this.userRoomsNotifier,
    required this.adminRoomNotifier,
    required this.userFoundNotifier,
    required this.userUseCases,
    required this.roomUsesCases,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageContent(
        selectedIndex: selectedIndex,
        isAdmin: isAdmin,
        userController: userController,
        userRoomsController: userRoomsController,
        logoutController: logoutController,
        roomsNotifier: roomsNotifier,
        usersNotifier: usersNotifier,
        roomController: roomController,
        selectedUserNotifier: selectedUserNotifier,
        userRoomsNotifier: userRoomsNotifier,
        adminRoomNotifier: adminRoomNotifier,
        userFoundNotifier: userFoundNotifier,
        userUseCases: userUseCases,
        roomUsesCases: roomUsesCases,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        isAdmin: isAdmin,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
