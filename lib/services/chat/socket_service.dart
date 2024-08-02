import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:my_app/models/message_socket.dart';

class SocketService {
  // Create a WebSocketChannel instance
  WebSocketChannel? _channel;

  // Create a connect method
  Future<void> connect(String roomId) async {
    // load .env file
    await dotenv.load(fileName: ".env");
    // get the socket URL from the .env file
    String? socketUrl = dotenv.env['SOCKET_URL'];
    // connect to the WebSocket
    _channel = WebSocketChannel.connect(Uri.parse('$socketUrl/ws?id=$roomId'));
    if (_channel == null) {
      // Return an error object
      throw Exception('Failed to connect to WebSocket');
    } else {
      // debug
      print('Connected to WebSocket');
      print('Channel: $_channel');
    }
  }

  // Create a sendMessage method
  void sendMessage(MessageSocket message) {
    if (_channel != null) {
      _channel!.sink.add(json.encode(message.toJson()));
      }
  }

  // Create a getter for the messages stream
  Stream<MessageSocket> get messages => _channel!.stream.map((event) {
    final jsonData = json.decode(event);
    return MessageSocket.fromJson(jsonData);
  });

  // Create a disconnect method
  void disconnect() {
    _channel?.sink.close();
  }
}
