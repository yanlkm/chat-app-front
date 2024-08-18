import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/presentation/cubits/admin/admin_code_cubit.dart';
import '../../../controllers/room/room_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../models/room.dart';
import '../../../models/user.dart';
import '../../cubits/admin/admin_rooms_cubit.dart';
import '../../cubits/admin/admin_users_cubit.dart';
import '../../views/admin/admin_view.dart';

class AdminPage extends StatelessWidget {
  final UserController userController;
  final RoomController roomController;
  final ValueNotifier<List<Room>> adminRoomNotifier;
  final ValueNotifier<User> selectedUserNotifier;
  final ValueNotifier<User> userFoundNotifier;
  final ValueNotifier<List<User>> userNotifier;
  final ValueNotifier<List<Room>> roomsNotifier;

  const AdminPage({
    super.key,
    required this.userController,
    required this.roomController,
    required this.adminRoomNotifier,
    required this.roomsNotifier,
    required this.selectedUserNotifier,
    required this.userFoundNotifier,
    required this.userNotifier,
  }) ;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit(userController, userFoundNotifier,
              userNotifier)..loadUsers(),
        ),
        BlocProvider(
          create: (context) =>
          RoomCubit(roomController, adminRoomNotifier, roomsNotifier)..loadRooms(),
        ),
        BlocProvider(
          create: (context) => AdminCodeCubit(userController),
        ),
      ],
      child: AdminView(
        adminRoomNotifier: adminRoomNotifier,
        userNotifier: userNotifier,
        selectedUserNotifier: selectedUserNotifier,
        userFoundNotifier: userFoundNotifier,

      ),
    );
  }
}
