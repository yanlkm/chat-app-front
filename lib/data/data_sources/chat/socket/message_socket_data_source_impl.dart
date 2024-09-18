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
  // WebSocketChannel instance
  WebSocketChannel? _channel;

  // StreamController instance for broadcasting messages
  final StreamController<MessageSocketModel> _controller = StreamController<MessageSocketModel>.broadcast();

  // To track the connection state
  bool _isConnected = false;

  // StreamSubscription to handle stream cleanup
  StreamSubscription? _subscription;

  // This method is used to connect to the socket
  @override
  Future<void> connect(String roomId) async {
    if (_isConnected) return; // Prevent multiple connections

    try {
      // Get the socket URL from the environment variables
      final String? socketUrl = dotenv.env['SOCKET_URL'];
      if (socketUrl == null || socketUrl.isEmpty) {
        throw const SocketErrorHandler('Socket URL is not defined in environment variables.');
      }

      // Create the WebSocketChannel instance
      final uri = Uri.tryParse('$socketUrl/ws?id=$roomId');
      if (uri == null) {
        throw SocketErrorHandler('Invalid Socket URL: $socketUrl/ws?id=$roomId');
      }

      // Connect to the WebSocket
      _channel = WebSocketChannel.connect(uri);
      _isConnected = true;

      // Cancel any previous subscription to prevent memory leaks
      await _subscription?.cancel();

      // Listen to the WebSocket stream
      _subscription = _channel!.stream.listen(
            (event) {
          if (_controller.isClosed) return; // Avoid adding to closed controller
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
          _isConnected = false;
          _subscription?.cancel(); // Cleanup subscription when done
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
    _isConnected = false;
    await _channel?.sink.close(status.normalClosure);
    _channel = null;

    // Cancel the stream subscription to stop receiving messages
    await _subscription?.cancel();
    _subscription = null;
  }

  // Optional: Clean up resources when no longer needed
  void dispose() {
    if (!_controller.isClosed) {
      _controller.close(); // Ensure controller is closed when done
    }
  }
}
