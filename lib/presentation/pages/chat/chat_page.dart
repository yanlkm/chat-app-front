import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import '../../../controllers/chat/message_controller.dart';
import '../../../controllers/chat/socket_controller.dart';
import '../../../domain/use_cases/chat/db/message_db_usecases.dart';
import '../../../domain/use_cases/chat/socket/message_socket_usescases.dart';
import '../../../models/room.dart';
import '../../cubits/chat/message_cubit.dart';
import '../../cubits/chat/socket_cubit.dart';
import '../../views/chat/chat_view.dart';

class ChatPage extends StatelessWidget {
  final RoomEntity room;
  final MessageDBUseCases messageDBUseCases;
  final MessageSocketUseCases messageSocketUseCases;

  const ChatPage({
    super.key,
    required this.room,
    required this.messageDBUseCases,
    required this.messageSocketUseCases,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MessageCubit(messageDBUseCases),
        ),
        BlocProvider(
          create: (context) => SocketCubit(messageSocketUseCases),
        ),
      ],
      child: ChatView(room: room),
    );
  }
}