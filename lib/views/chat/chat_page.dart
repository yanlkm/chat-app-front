import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/models/room.dart';
import 'package:my_app/models/message_socket.dart';
import 'package:my_app/models/message.dart';
import 'package:my_app/views/utils/error_popup.dart';
import '../../controllers/chat/message_controller.dart';
import '../../controllers/chat/socket_controller.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final Room room;

  const ChatPage({Key? key, required this.room}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final SocketController _socketController = SocketController();
  final MessageController _messageController = MessageController();
  final TextEditingController _messageControllerInput = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  String? _username;
  String? _userId;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchMessages();
    _connectToRoom();
    _messageControllerInput.addListener(_scrollToBottom);
  }

  Future<void> _loadUsername() async {
    _username = await const FlutterSecureStorage().read(key: 'username');
    _userId = await const FlutterSecureStorage().read(key: 'userId');
  }

  Future<void> _fetchMessages() async {
    try {
      final messages = await _messageController.getMessages(widget.room.roomID);
      setState(() {
        _messages.addAll(messages);
      });
      _scrollToBottom();
    } catch (e) {
      ErrorDisplayIsolate.showErrorDialog(context, 'Failed to fetch messages. Please try again.');
    }
  }

  Future<void> _connectToRoom() async {
    try {
      await _socketController.connectToRoom(widget.room.roomID);
      setState(() {
        _isConnected = true;
      });
      _socketController.messages.listen((message) {
        setState(() {
          _messages.add(Message(
            messageID: message.roomId,
            roomID: message.roomId,
            username: message.username,
            userId: message.userId,
            content: message.message,
            createdAt: DateTime.now(),
          ));
        });
        _scrollToBottom();
      });
    } catch (e) {
      ErrorDisplayIsolate.showErrorDialog(context, 'Failed to fetch messages. Please try again.');
    }
  }

  @override
  void dispose() {
    _socketController.disconnect();
    _messageControllerInput.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageControllerInput.text.isNotEmpty && _isConnected) {
      final message = MessageSocket(
        roomId: widget.room.roomID,
        username: _username!,
        message: _messageControllerInput.text,
        userId: _userId!,
      );
      _socketController.sendMessage(message);
      _messageControllerInput.clear();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  String _formatDateIndicator(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM dd, yyyy').format(date);
    }
  }

  List<Widget> _buildMessageList() {
    List<Widget> messageList = [];
    DateTime? lastDate;

    for (var msg in _messages) {
      final msgDate = msg.createdAt!;
      if (lastDate == null || msgDate.day != lastDate.day || msgDate.month != lastDate.month || msgDate.year != lastDate.year) {
        messageList.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Text(
                _formatDateIndicator(msgDate),
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
        lastDate = msgDate;
      }

      final formattedTime = DateFormat('HH:mm').format(msgDate);

      messageList.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: msg.userId == _userId
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 2 / 3,
                ),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: msg.userId == _userId
                        ? Colors.blue[100]
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: msg.userId != _userId
                        ? Border.all(color: Colors.black)
                        : null,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg.username!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            msg.content!,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10), // Adding space between the text and the time
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Text(
                          formattedTime,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return messageList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name ?? 'Chat'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: _buildMessageList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageControllerInput,
                      decoration: const InputDecoration(
                        hintText: 'Enter message',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
