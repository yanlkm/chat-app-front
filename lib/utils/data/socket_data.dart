import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../errors/handlers/socket_error_handler.dart';

// SocketData : socket data class
class SocketData {
  // channel
  WebSocketChannel? _channel;
  // stream controller : the controller for the stream to handle incoming data
  final StreamController<dynamic> _controller = StreamController<dynamic>.broadcast();

  /// Connect to the WebSocket server
  Future<void> connect(String roomId) async {
    try {
      // Load environment variables
      await dotenv.load(fileName: ".env");
      final String? socketUrl = dotenv.env['SOCKET_URL'];

      // Check if the socket URL is defined
      if (socketUrl == null || socketUrl.isEmpty) {
        throw const SocketErrorHandler('Socket URL is not defined in environment variables.');
      }
      // Create the WebSocket channel
      final uri = Uri.tryParse('$socketUrl/ws?id=$roomId');

      // Check if the URI is valid
      if (uri == null) {
        throw SocketErrorHandler('Invalid Socket URL: $socketUrl/ws?id=$roomId');
      }
      // Connect to the WebSocket server if the URI is valid
      _channel = WebSocketChannel.connect(uri);
      // Listen to the stream of incoming data
      _channel!.stream.listen(
            (event) {
          _handleIncomingData(event);
        },
        // Handle errors
        onError: (error) {
          _controller.addError(SocketErrorHandler.fromException(error));
          disconnect();
        },
        // Handle when the connection is done
        onDone: () {
          _controller.close();
        },
        cancelOnError: true,
      );
    } catch (e) {
      throw SocketErrorHandler.fromException(e);
    }
  }

  /// Handle incoming data from the WebSocket stream
  void _handleIncomingData(dynamic event) {
    try {
      final data = json.decode(event);
      _controller.add(data);
    } catch (e) {
      _controller.addError(SocketErrorHandler.fromException(e));
    }
  }

  /// Send a message over the WebSocket connection
  void sendMessage(dynamic message) {
    if (_channel == null) {
      throw const SocketErrorHandler('WebSocket connection is not established.');
    }
    try {
      final encodedMessage = json.encode(message);
      _channel!.sink.add(encodedMessage);
    } catch (e) {
      throw SocketErrorHandler.fromException(e);
    }
  }

  /// Get the stream of messages
  Stream<dynamic> get messages => _controller.stream;

  /// Disconnect from the WebSocket server
  Future<void> disconnect() async {
    try {
      await _channel?.sink.close(status.normalClosure);
    } catch (e) {
      throw SocketErrorHandler.fromException(e);
    } finally {
      _channel = null;
    }
  }
}
