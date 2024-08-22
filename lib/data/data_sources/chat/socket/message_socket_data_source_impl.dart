import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../../models/chat/socket/message_socket_model.dart';
import 'message_socket_data_source.dart';


class MessageSocketDataSourceImpl implements MessageSocketDataSource {
  WebSocketChannel? _channel;
  final StreamController<MessageSocketModel> _controller = StreamController<MessageSocketModel>.broadcast();

  @override
  Future<void> connect(String roomId) async {
    try {
      final String? socketUrl = dotenv.env['SOCKET_URL'];
      if (socketUrl == null || socketUrl.isEmpty) {
        throw Exception('Socket URL is not defined in environment variables.');
      }

      final uri = Uri.tryParse('$socketUrl/ws?id=$roomId');
      if (uri == null) {
        throw Exception('Invalid Socket URL: $socketUrl/ws?id=$roomId');
      }

      _channel = WebSocketChannel.connect(uri);
      _channel!.stream.listen(
            (event) {
          final message = MessageSocketModel.fromJson(json.decode(event));
          _controller.add(message);
        },
        onError: (error) {
          _controller.addError(error);
          disconnect();
        },
        onDone: () {
          _controller.close();
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
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }

  @override
  Stream<MessageSocketModel> get messages => _controller.stream;

  @override
  Future<void> disconnect() async {
    await _channel?.sink.close(status.normalClosure);
    _channel = null;
  }
}
