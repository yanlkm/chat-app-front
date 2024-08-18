import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controllers/chat/message_controller.dart';
import '../../../controllers/chat/socket_controller.dart';
import '../../../models/room.dart';
import '../../cubits/chat/message_cubit.dart';
import '../../cubits/chat/socket_cubit.dart';
import '../../views/chat/chat_view.dart';

class ChatPage extends StatelessWidget {
  final Room room;

  const ChatPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageCubit(MessageController()),
      child: BlocProvider(
        create: (context) => SocketCubit(SocketController()),
        child: ChatView(room: room),
      ),
    );
  }
}
