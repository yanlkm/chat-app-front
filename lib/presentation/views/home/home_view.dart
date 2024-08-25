import 'package:flutter/material.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import '../../../domain/use_cases/authentication/auth_usecases.dart';
import '../../../domain/use_cases/chat/db/message_db_usecases.dart';
import '../../../domain/use_cases/chat/socket/message_socket_usescases.dart';
import '../../../domain/use_cases/rooms/room_usecases.dart';
import '../../../domain/use_cases/users/user_usecases.dart';
import '../../_widgets/home/bottom_navigation_widget.dart';
import '../../_widgets/home/page_content.dart';

class HomeView extends StatelessWidget {
  final int selectedIndex;
  final bool isAdmin;
  final Function(int) onItemTapped;

  // usesCases
  final UserUseCases userUseCases;
  final RoomUsesCases roomUsesCases;
  final AuthUseCases authUseCases;
  final MessageDBUseCases messageDBUseCases;
  final MessageSocketUseCases   messageSocketUseCases;

  final ValueNotifier<List<RoomEntity>> roomsNotifier;
  final ValueNotifier<List<UserEntity>> usersNotifier;
  final ValueNotifier<List<RoomEntity>> userRoomsNotifier;
  final ValueNotifier<UserEntity> selectedUserNotifier;
  final ValueNotifier<UserEntity> userFoundNotifier;
  final ValueNotifier<List<RoomEntity>> adminRoomNotifier;

  const HomeView({
    Key? key,
    required this.selectedIndex,
    required this.isAdmin,
    required this.onItemTapped,
    required this.roomsNotifier,
    required this.usersNotifier,
    required this.selectedUserNotifier,
    required this.userRoomsNotifier,
    required this.adminRoomNotifier,
    required this.userFoundNotifier,
    required this.userUseCases,
    required this.roomUsesCases,
    required this.authUseCases,
    required this.messageDBUseCases,
    required this.messageSocketUseCases,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageContent(
        selectedIndex: selectedIndex,
        isAdmin: isAdmin,
        roomsNotifier: roomsNotifier,
        usersNotifier: usersNotifier,
        selectedUserNotifier: selectedUserNotifier,
        userRoomsNotifier: userRoomsNotifier,
        adminRoomNotifier: adminRoomNotifier,
        userFoundNotifier: userFoundNotifier,
        userUseCases: userUseCases,
        roomUsesCases: roomUsesCases,
        authUseCases: authUseCases,
        messageDBUseCases: messageDBUseCases,
        messageSocketUseCases: messageSocketUseCases,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        isAdmin: isAdmin,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
