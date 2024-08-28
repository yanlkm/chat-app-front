import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_app/utils/errors/handlers/socket_error_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../../models/chat/socket/message_socket_model.dart';
import 'message_socket_data_source.dart';

// This class is the implementation of the MessageSocketDataSource
class MessageSocketDataSourceImpl implements MessageSocketDataSource {
  // This is the WebSocketChannel instance
  WebSocketChannel? _channel;
  // This is the StreamController instance
  final StreamController<MessageSocketModel> _controller = StreamController<MessageSocketModel>.broadcast();
  bool _isConnected = false; // To track the connection state

  // This method is used to connect to the socket
  @override
  Future<void> connect(String roomId) async {
    if (_isConnected) return; // Prevent multiple connections

    // Get the socket URL from the environment variables
    try {
      // Get the socket URL from the environment variables
      final String? socketUrl = dotenv.env['SOCKET_URL'];
      if (socketUrl == null || socketUrl.isEmpty) {
        throw const SocketErrorHandler('Socket URL is not defined in environment variables.');
      }
      // Create the WebSocketChannel instance
      final uri = Uri.tryParse('$socketUrl/ws?id=$roomId');
      // Check if the URI is valid
      if (uri == null) {
        throw SocketErrorHandler('Invalid Socket URL: $socketUrl/ws?id=$roomId');
      }
      // Connect to the socket
      _channel = WebSocketChannel.connect(uri);
      _isConnected = true;

      // Listen to the stream
      _channel!.stream.listen(
            (event) {
              // Check if the controller is closed
          if (_controller.isClosed) return; // Check if the controller is closed
          final message = MessageSocketModel.fromJson(json.decode(event));
          _controller.add(message);
        },
        // Handle errors
        onError: (error) {
          if (!_controller.isClosed) {
            _controller.addError(error);
          }
          disconnect(); // Disconnect on error
        },
        // Handle connection close
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

  // This method is used to send a message to the socket
  @override
  void sendMessage(MessageSocketModel message) {
    if (_channel == null) {
      throw Exception('WebSocket connection is not established.');
    }
    // Encode the message and send it
    try {
      final encodedMessage = json.encode(message.toJson());
      _channel!.sink.add(encodedMessage);
    } catch (e) {
      throw SocketErrorHandler('Failed to send message: ${e.toString()}');
    }
  }

  // This method is used to get the messages from the socket
  @override
  Stream<MessageSocketModel> get messages => _controller.stream;

  // This method is used to disconnect from the socket
  @override
  Future<void> disconnect() async {
    //  Disconnect only if currently connected
    if (!_isConnected) return; // Only disconnect if currently connected
    _isConnected = false;
    await _channel?.sink.close(status.normalClosure);
    _channel = null;

    if (!_controller.isClosed) {
      await _controller.close(); // Ensure controller is closed only if it's not already closed
    }
  }
}
