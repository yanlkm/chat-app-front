import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/controllers/user/user_controller.dart';
import 'package:my_app/domain/use_cases/rooms/room_usecases.dart';
import 'package:my_app/domain/use_cases/users/user_usecases.dart';
import '../../../controllers/authentification/logout_controller.dart';

import '../../../controllers/user/user_rooms_controller.dart';
import '../../../models/room.dart';
import '../../cubits/profile/password_cubit.dart';
import '../../cubits/profile/profile_cubit.dart';
import '../../cubits/profile/rooms_cubit.dart';
import '../../views/profile/profile_view.dart';

class ProfilePage extends StatelessWidget {
  final UserUseCases userUseCases;
  final RoomUsesCases roomUsesCases;
  final UserRoomsController userRoomsController;
  final LogoutController logoutController;
  final ValueNotifier<List<Room>> userRoomNotifier;

  const ProfilePage({
    super.key,
    required this.userUseCases,
    required this.userRoomsController,
    required this.logoutController,
    required this.userRoomNotifier,
    required this.roomUsesCases,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit(userUseCases)..loadProfile(),
        ),
        BlocProvider(
          create: (context) => RoomsCubit(roomUsesCases, userRoomNotifier)..loadRooms(),
        ),
        BlocProvider(
          create: (context) => PasswordCubit(userUseCases),
        ),
      ],
      child: ProfileView(
        logoutController: logoutController,
      ),
    );
  }
}