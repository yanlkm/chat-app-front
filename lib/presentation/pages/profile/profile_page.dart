import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';
import 'package:my_app/domain/use_cases/rooms/room_usecases.dart';
import 'package:my_app/domain/use_cases/users/user_usecases.dart';
import '../../cubits/profile/password_cubit.dart';
import '../../cubits/profile/profile_cubit.dart';
import '../../cubits/profile/rooms_cubit.dart';
import '../../views/profile/profile_view.dart';

// ProfilePage : profile page entry point
class ProfilePage extends StatelessWidget {
  // UseCases
  final UserUseCases userUseCases;
  final RoomUsesCases roomUsesCases;
  final AuthUseCases authUseCases;
  // notifier
  final ValueNotifier<List<RoomEntity>> userRoomNotifier;

  // Constructor
  const ProfilePage({
    super.key,
    required this.userUseCases,
    required this.authUseCases,
    required this.userRoomNotifier,
    required this.roomUsesCases,
  });

  // build method
  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider : provider for multiple blocs in the widget tree
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
        authUseCases: authUseCases,
      ),
    );
  }
}