import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';
import 'package:my_app/domain/use_cases/rooms/room_usecases.dart';
import 'package:my_app/domain/use_cases/users/user_usecases.dart';
import 'package:my_app/presentation/cubits/admin/admin_code_cubit.dart';
import '../../cubits/admin/admin_rooms_cubit.dart';
import '../../cubits/admin/admin_users_cubit.dart';
import '../../views/admin/admin_view.dart';
// AdminPage : admin page entry point
class AdminPage extends StatelessWidget {
  // UseCases
  final UserUseCases userUseCases;
  final AuthUseCases authUseCases;
  final RoomUsesCases roomUsesCases;
  // notifiers
  final ValueNotifier<List<RoomEntity>> adminRoomNotifier;
  final ValueNotifier<UserEntity> selectedUserNotifier;
  final ValueNotifier<UserEntity> userFoundNotifier;
  final ValueNotifier<List<UserEntity>> userNotifier;
  final ValueNotifier<List<RoomEntity>> roomsNotifier;

  //  Constructor
  const AdminPage({
    super.key,
    required this.adminRoomNotifier,
    required this.roomsNotifier,
    required this.selectedUserNotifier,
    required this.userFoundNotifier,
    required this.userNotifier,
    required this.userUseCases,
    required this.authUseCases,
    required this.roomUsesCases,
  }) ;

  // build method
  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider : provider for multiple blocs in the widget tree
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit(userUseCases, userFoundNotifier,
              userNotifier)..loadUsers(),
        ),
        BlocProvider(
          create: (context) =>
          RoomCubit(roomUsesCases, roomsNotifier, adminRoomNotifier
          )..loadRooms(),
        ),
        BlocProvider(
          create: (context) => AdminCodeCubit(
            userUseCases
          ),
        ),
      ],
      child: AdminView(
        adminRoomNotifier: adminRoomNotifier,
        authUseCases: authUseCases,
        userNotifier: userNotifier,
        selectedUserNotifier: selectedUserNotifier,
        userFoundNotifier: userFoundNotifier,


      ),
    );
  }
}
