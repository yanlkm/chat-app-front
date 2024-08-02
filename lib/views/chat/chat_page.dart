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
  // Add the room property
  final Room room;

  // Add the room to the constructor
  const ChatPage({super.key, required this.room});

  //  Add the createState method
  @override
  _ChatPageState createState() => _ChatPageState();
}

// Add the _ChatPageState class
class _ChatPageState extends State<ChatPage> {
  // Add the socketController and messageController properties
  final SocketController _socketController = SocketController();
  final MessageController _messageController = MessageController();
  final TextEditingController _messageControllerInput = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  // Add the username and userId properties
  String? _username;
  String? _userId;
  bool _isConnected = false;

  // Add the initState method
  @override
  void initState() {
    super.initState();
    // Add the _loadUsername, _fetchMessages, and _connectToRoom methods
    _loadUsername();
    _fetchMessages();
    _connectToRoom();
    // Add the _scrollController listener
    _messageControllerInput.addListener(_scrollToBottom);
  }

  // Add the _loadUsername method
  Future<void> _loadUsername() async {
    // load username and userId from secure storage
    _username = await const FlutterSecureStorage().read(key: 'username');
    _userId = await const FlutterSecureStorage().read(key: 'userId');
  }

  Future<void> _fetchMessages() async {
    try {
      // fetch messages from the server
      final messages = await _messageController.getMessages(widget.room.roomID);
      // add messages to the _messages list
      setState(() {
        _messages.addAll(messages);
      });
      // scroll to the bottom of the list
      _scrollToBottom();
    } catch (e) {
      // show an error dialog if the messages fail to load
      ErrorDisplayIsolate.showErrorDialog(context, 'Failed to fetch messages. Please try again.');
    }
  }

  // Add the _connectToRoom method
  Future<void> _connectToRoom() async {
    try {
      // connect to the room
      await _socketController.connectToRoom(widget.room.roomID);
      // set the _isConnected property to true
      setState(() {
        _isConnected = true;
      });
      // listen for messages
      _socketController.messages.listen((message) {
        setState(() {
          // add the message to the _messages list
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
      // show an error dialog if the connection fails
      ErrorDisplayIsolate.showErrorDialog(context, 'Failed to fetch messages. Please try again.');
    }
  }

  // Add the dispose method
  @override
  void dispose() {
    // disconnect from the room
    _socketController.disconnect();
    _messageControllerInput.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Add the _sendMessage method
  void _sendMessage() {
    // send a message if the input is not empty and the user is connected
    if (_messageControllerInput.text.isNotEmpty && _isConnected) {
      final message = MessageSocket(
        roomId: widget.room.roomID,
        username: _username!,
        message: _messageControllerInput.text,
        userId: _userId!,
      );
      // send the message
      _socketController.sendMessage(message);
      _messageControllerInput.clear();
    }
  }

  //  Add the _scrollToBottom method
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  // Add the _formatDateIndicator method to format the date and indicate if it is today or yesterday or another date
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

  // Add the _buildMessageList method
  List<Widget> _buildMessageList() {
    List<Widget> messageList = [];
    DateTime? lastDate;

    // Add the messages to the messageList
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

      // format the time
      final formattedTime = DateFormat('HH:mm').format(msgDate);

      // add the message to the messageList
      messageList.add(
        Padding(
          // Add padding to the message
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
                // Add the message container
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
                      // Add the message content
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
    // return the messageList
    return messageList;
  }

  // Add the build method
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
                // Add the scrollController
                controller: _scrollController,
                // Add the children : the messages from the _buildMessageList method
                children: _buildMessageList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Add the text field
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
