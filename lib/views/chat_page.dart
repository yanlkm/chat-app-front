import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/models/room.dart';
import 'package:my_app/models/message_socket.dart';

import '../controllers/chat/socket_controller.dart';

class ChatPage extends StatefulWidget {
  final Room room;

  const ChatPage({Key? key, required this.room}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final SocketController _socketController = SocketController();
  final TextEditingController _messageController = TextEditingController();
  final List<MessageSocket> _messages = [];
  String? _username;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _connectToRoom();
  }

  Future<void> _loadUsername() async {
    _username = await FlutterSecureStorage().read(key: 'username');
  }

  Future<void> _connectToRoom() async {
    try {
      await _socketController.connectToRoom(widget.room.roomID);
      setState(() {
        _isConnected = true;
      });
      _socketController.messages.listen((message) {
        setState(() {
          _messages.add(message);
        });
      });
    } catch (e) {
      print('Error connecting to WebSocket: $e');
    }
  }

  @override
  void dispose() {
    _socketController.disconnect();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty && _isConnected) {
      final message = MessageSocket(
        roomId: widget.room.roomID,
        username: _username as String,
        message: _messageController.text,
      );
      _socketController.sendMessage(message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name ?? 'Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: msg.username == _username
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: msg.username == _username
                                ? Colors.blue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg.username!,
                                style: TextStyle(
                                  color: msg.username == _username
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                msg.message!,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
