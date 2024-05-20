import 'package:my_app/models/message_socket.dart';

import '../../services/chat/socket_service.dart';

class SocketController {
  final SocketService _socketService = SocketService();

  Future<void> connectToRoom(String roomId) async {
    await _socketService.connect(roomId);
  }

  void sendMessage(MessageSocket message) {
    _socketService.sendMessage(message);
  }

  Stream<MessageSocket> get messages => _socketService.messages;

  void disconnect() {
    _socketService.disconnect();
  }
}
