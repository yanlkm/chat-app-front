import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import '../../../controllers/chat/message_controller.dart';
import '../../../controllers/chat/socket_controller.dart';
import '../../../domain/entities/chat/db/message_db_entity.dart';
import '../../../domain/entities/chat/socket/message_socket_entity.dart';
import '../../../models/message.dart';
import '../../../models/message_socket.dart';
import '../../../models/room.dart';
import '../../../views/utils/error_popup.dart';
import '../../_widgets/chat/chat_input_widget.dart';
import '../../_widgets/chat/message_list_widget.dart';
import '../../cubits/chat/message_cubit.dart';
import '../../cubits/chat/socket_cubit.dart';
class ChatView extends StatefulWidget {
  final RoomEntity room;

  const ChatView({super.key, required this.room});

  @override
  ChatViewState createState() => ChatViewState();
}

class ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  final TextEditingController _messageControllerInput = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _username;
  String? _userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUsername();
    _initializeCubits();
    _connectAndFetchMessages();
  }

  Future<void> _loadUsername() async {
    _username = await const FlutterSecureStorage().read(key: 'username');
    _userId = await const FlutterSecureStorage().read(key: 'userId');
  }

  void _initializeCubits() {
    final messageCubit = context.read<MessageCubit>();
    messageCubit.fetchMessages(widget.room.roomID);

    // Scroll to the bottom after messages are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      messageCubit.stream.listen((messages) {
        if (messages.isNotEmpty) {
          _scrollToBottom();
        }
      });
    });
  }

  void _connectAndFetchMessages() async {
    final socketCubit = context.read<SocketCubit>();
    await socketCubit.connectToRoom(widget.room.roomID);

    if (socketCubit.state) {
      socketCubit.listenToMessages((message) {
        context.read<MessageCubit>().addMessage(
          MessageDBEntity(
            messageID: message.roomId,
            roomID: message.roomId,
            username: message.username,
            userId: message.userId,
            content: message.message,
            createdAt: DateTime.now(),
          ),
        );
        _scrollToBottom();
      });
    } else {
      ErrorDisplayIsolate.showErrorDialog(
          context, 'Failed to connect to the room. Please try again.');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageControllerInput.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageControllerInput.text.isNotEmpty) {
      final message = MessageSocketEntity(
        roomId: widget.room.roomID,
        username: _username!,
        message: _messageControllerInput.text,
        userId: _userId!,
      );
      context.read<SocketCubit>().sendMessage(message);
      _messageControllerInput.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    if (bottomInset > 0.0) {
      _scrollToBottom();
    }
  }

  void _exitChatRoom() {
    context.read<SocketCubit>().disconnect();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: _exitChatRoom,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.room.name ?? 'Chat',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.group, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  widget.room.members!.length > 99
                      ? '+99'
                      : widget.room.members!.length.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Roboto', fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessageCubit, List<MessageDBEntity>>(
                builder: (context, messages) {
                  return MessageListWidget(
                    messages: messages,
                    currentUserId: _userId,
                    scrollController: _scrollController,
                  );
                },
              ),
            ),
            ChatInputWidget(
              messageController: _messageControllerInput,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}