import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_app/utils/errors/handlers/socket_error_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../../models/chat/socket/message_socket_model.dart';
import 'message_socket_data_source.dart';

class MessageSocketDataSourceImpl implements MessageSocketDataSource {
  WebSocketChannel? _channel;
  final StreamController<MessageSocketModel> _controller = StreamController<MessageSocketModel>.broadcast();
  bool _isConnected = false; // To track the connection state

  @override
  Future<void> connect(String roomId) async {
    if (_isConnected) return; // Prevent multiple connections

    try {
      final String? socketUrl = dotenv.env['SOCKET_URL'];
      if (socketUrl == null || socketUrl.isEmpty) {
        throw const SocketErrorHandler('Socket URL is not defined in environment variables.');
      }

      final uri = Uri.tryParse('$socketUrl/ws?id=$roomId');
      if (uri == null) {
        throw SocketErrorHandler('Invalid Socket URL: $socketUrl/ws?id=$roomId');
      }

      _channel = WebSocketChannel.connect(uri);
      _isConnected = true;

      _channel!.stream.listen(
            (event) {
          if (_controller.isClosed) return; // Check if the controller is closed
          final message = MessageSocketModel.fromJson(json.decode(event));
          _controller.add(message);
        },
        onError: (error) {
          if (!_controller.isClosed) {
            _controller.addError(error);
          }
          disconnect(); // Disconnect on error
        },
        onDone: () {
          if (!_controller.isClosed) {
            _controller.close(); // Close the controller only if it's not already closed
          }
          _isConnected = false; // Update connection state
        },
        cancelOnError: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  void sendMessage(MessageSocketModel message) {
    if (_channel == null) {
      throw Exception('WebSocket connection is not established.');
    }
    try {
      final encodedMessage = json.encode(message.toJson());
      _channel!.sink.add(encodedMessage);
    } catch (e) {
      throw SocketErrorHandler('Failed to send message: ${e.toString()}');
    }
  }

  @override
  Stream<MessageSocketModel> get messages => _controller.stream;

  @override
  Future<void> disconnect() async {
    if (!_isConnected) return; // Only disconnect if currently connected
    _isConnected = false;
    await _channel?.sink.close(status.normalClosure);
    _channel = null;

    if (!_controller.isClosed) {
      await _controller.close(); // Ensure controller is closed only if it's not already closed
    }
  }
}
