import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import '../../../domain/entities/chat/db/message_db_entity.dart';
import '../../../domain/entities/chat/socket/message_socket_entity.dart';
import '../../_widgets/chat/chat_input_widget.dart';
import '../../_widgets/chat/message_list_widget.dart';
import '../../cubits/chat/message_cubit.dart';
import '../../cubits/chat/socket_cubit.dart';

// ChatView : chat view class
class ChatView extends StatefulWidget {
  // RoomEntity
  final RoomEntity room;

  // Constructor
  const ChatView({super.key, required this.room});

  // createState method
  @override
  ChatViewState createState() => ChatViewState();
}

// ChatViewState : ChatView state class
class ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  // attributes
  // TextEditingController & ScrollController  : message controller and scroll controller
  final TextEditingController _messageControllerInput = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // username & userId to store the username and userId
  String? _username;
  String? _userId;

  // initState method : initialize the state and load the username
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUsername();
    _initializeCubits();
    _connectAndFetchMessages();
  }

  // _loadUsername method : load the username
  Future<void> _loadUsername() async {
    _username = await const FlutterSecureStorage().read(key: 'username');
    _userId = await const FlutterSecureStorage().read(key: 'userId');
  }

  // _initializeCubits method : initialize the cubits
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

  // _connectAndFetchMessages method : connect to the room and fetch messages
  void _connectAndFetchMessages() async {
    // connect to the room
    final socketCubit = context.read<SocketCubit>();
    await socketCubit.connectToRoom(widget.room.roomID);

    // listen to messages : if the connection is successful
    if (socketCubit.state) {
      socketCubit.listenToMessages((message) {
        // add the message to the cubit
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
        // scroll to the bottom
        _scrollToBottom();
      });
    } else {
     // scaffold with error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to connect to the room'),
          ),
        );
      }
    }
  }

  // dispose method : dispose the controllers and remove the observer

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageControllerInput.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // _sendMessage method : send a message
  void _sendMessage() {
    if (_messageControllerInput.text.isNotEmpty) {
      final message = MessageSocketEntity(
        roomId: widget.room.roomID,
        username: _username!,
        message: _messageControllerInput.text,
        userId: _userId!,
      );
      context.read<SocketCubit>().sendMessage(message);
      // clear the message controller
      _messageControllerInput.clear();
      // scroll to the bottom
      _scrollToBottom();
    }
  }

  // _scrollToBottom method : scroll to the bottom
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  // didChangeMetrics method : handle the keyboard event
  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    if (bottomInset > 0.0) {
      _scrollToBottom();
    }
  }

  // _exitChatRoom method : exit the chat room
  void _exitChatRoom() {
    // disconnect from the room
    context.read<SocketCubit>().disconnect();
    // pop the context
    Navigator.of(context).pop();
  }

  // build method : build the widget
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
                  // Display the number of members : if members > 99 display '+99'
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
        // onTap : unfocused the context
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