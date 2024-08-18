import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controllers/authentification/logout_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../controllers/user/user_rooms_controller.dart';
import '../../../models/room.dart';
import '../../cubits/profile/password_cubit.dart';
import '../../cubits/profile/profile_cubit.dart';
import '../../cubits/profile/rooms_cubit.dart';
import '../../views/profile/profile_view.dart';

class ProfilePage extends StatelessWidget {
  final UserController userController;
  final UserRoomsController userRoomsController;
  final LogoutController logoutController;
  final ValueNotifier<List<Room>> userRoomNotifier;

  const ProfilePage({
    super.key,
    required this.userController,
    required this.userRoomsController,
    required this.logoutController,
    required this.userRoomNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit(userController)..loadProfile(),
        ),
        BlocProvider(
          create: (context) => RoomsCubit(userRoomsController, userRoomNotifier)..loadRooms(),
        ),
        BlocProvider(
          create: (context) => PasswordCubit(userController),
        ),
      ],
      child: ProfileView(
        logoutController: logoutController,
      ),
    );
  }
}