import 'package:flutter/material.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import 'package:my_app/domain/use_cases/users/user_usecases.dart';
import 'package:my_app/presentation/pages/admin/admin_page.dart';
import 'package:my_app/presentation/pages/profile/profile_page.dart';
import 'package:my_app/presentation/pages/rooms/rooms_page.dart';
import '../../../domain/use_cases/authentication/auth_usecases.dart';
import '../../../domain/use_cases/chat/db/message_db_usecases.dart';
import '../../../domain/use_cases/chat/socket/message_socket_usescases.dart';
import '../../../domain/use_cases/rooms/room_usecases.dart';

// PageContent : the main content of the home page
class PageContent extends StatelessWidget {
  final int selectedIndex;
  final bool isAdmin;

  // userUseCases
  final UserUseCases userUseCases;
  final RoomUsesCases roomUsesCases;
  final AuthUseCases authUseCases;
  final MessageDBUseCases messageDBUseCases;
  final MessageSocketUseCases messageSocketUseCases;

  // notifiers
  late ValueNotifier<List<RoomEntity>> roomsNotifier;
  late ValueNotifier<List<UserEntity>> usersNotifier;
  late ValueNotifier<UserEntity> selectedUserNotifier;
  late ValueNotifier<UserEntity> userFoundNotifier;
  late ValueNotifier<List<RoomEntity>> userRoomsNotifier;
  late ValueNotifier<List<RoomEntity>> adminRoomNotifier;

  // Constructor
  PageContent({
    super.key,
    required this.selectedIndex,
    required this.isAdmin,
    required this.roomsNotifier,
    required this.usersNotifier,
    required this.selectedUserNotifier,
    required this.userFoundNotifier,
    required this.userRoomsNotifier,
    required this.adminRoomNotifier,
    required this.userUseCases,
    required this.roomUsesCases,
    required this.authUseCases,
    required this.messageDBUseCases,
    required this.messageSocketUseCases,
  });

  // main build method that returns an IndexedStack with the ProfilePage, RoomPage, and AdminPage
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: selectedIndex,
      children: [
        ProfilePage(
          userUseCases: userUseCases,
          authUseCases: authUseCases,
          roomUsesCases: roomUsesCases,
          userRoomNotifier: userRoomsNotifier,
        ),
        RoomPage(
          authUseCases: authUseCases,
          roomUseCases: roomUsesCases,
          userUseCases: userUseCases,
          messageDBUseCases: messageDBUseCases,
          messageSocketUseCases: messageSocketUseCases,
          roomsNotifier: roomsNotifier,
          userRoomsNotifier: userRoomsNotifier,
        ),
        if (isAdmin)
          AdminPage(
            adminRoomNotifier: adminRoomNotifier,
            userUseCases: userUseCases,
            userNotifier: usersNotifier,
            userFoundNotifier: userFoundNotifier,
            selectedUserNotifier: selectedUserNotifier,
            roomsNotifier: roomsNotifier,
            authUseCases: authUseCases,
            roomUsesCases: roomUsesCases,
          ),
      ],
    );
  }
}
