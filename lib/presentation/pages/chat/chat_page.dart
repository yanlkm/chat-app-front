import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import '../../../domain/use_cases/chat/db/message_db_usecases.dart';
import '../../../domain/use_cases/chat/socket/message_socket_usescases.dart';
import '../../cubits/chat/message_cubit.dart';
import '../../cubits/chat/socket_cubit.dart';
import '../../views/chat/chat_view.dart';

// ChatPage : chat page entry point
class ChatPage extends StatelessWidget {
  // RoomEntity
  final RoomEntity room;
  // UseCases
  final MessageDBUseCases messageDBUseCases;
  final MessageSocketUseCases messageSocketUseCases;

  // Constructor
  const ChatPage({
    super.key,
    required this.room,
    required this.messageDBUseCases,
    required this.messageSocketUseCases,
  });

  // build method
  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider : provider for multiple blocs in the widget tree
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