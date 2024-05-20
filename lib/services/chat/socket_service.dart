import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:my_app/models/message_socket.dart';

class SocketService {
  WebSocketChannel? _channel;

  Future<void> connect(String roomId) async {
    await dotenv.load(fileName: ".env");
    String? socketUrl = dotenv.env['SOCKET_URL'];
    _channel = WebSocketChannel.connect(Uri.parse('$socketUrl/ws?id=$roomId'));
    if (_channel == null) {
      throw Exception('Failed to connect to WebSocket');
    } else {
      // debug
      print('Connected to WebSocket');
      print('Channel: $_channel');
    }
  }

  void sendMessage(MessageSocket message) {
    if (_channel != null) {
      _channel!.sink.add(json.encode(message.toJson()));
      }
  }

  Stream<MessageSocket> get messages => _channel!.stream.map((event) {
    final jsonData = json.decode(event);
    return MessageSocket.fromJson(jsonData);
  });

  void disconnect() {
    _channel?.sink.close();
  }
}
