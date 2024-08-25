import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/rooms/room_entity.dart';
import '../../../domain/use_cases/authentication/auth_usecases.dart';
import '../../../domain/use_cases/rooms/room_usecases.dart';
import '../../../domain/use_cases/users/user_usecases.dart';
import '../../cubits/rooms/rooms_cubit.dart';
import '../../views/rooms/rooms_view.dart';


class RoomPage extends StatelessWidget {
  // useCases
  final AuthUseCases authUseCases;
  final RoomUsesCases roomUseCases;
  final UserUseCases userUseCases;
  // notifiers
  final ValueNotifier<List<RoomEntity>> roomsNotifier;
  final ValueNotifier<List<RoomEntity>> userRoomsNotifier;

  const RoomPage({
    super.key,
    required this.authUseCases,
    required this.roomUseCases,
    required this.userUseCases,
    required this.roomsNotifier,
    required this.userRoomsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomsCubit(
        roomUseCases,
        roomsNotifier,
        userRoomsNotifier,
      )..loadRooms(context),
      child: RoomView(
        authUseCases: authUseCases,
        roomsNotifier: roomsNotifier,
      ),
    );
  }
}