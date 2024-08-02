import 'package:my_app/models/message_socket.dart';

import '../../services/chat/socket_service.dart';

class SocketController {
  //  Create an instance of the service
  final SocketService _socketService = SocketService();

  // Constructor
  Future<void> connectToRoom(String roomId) async {
    await _socketService.connect(roomId);
  }

  // Send message
  void sendMessage(MessageSocket message) {
    _socketService.sendMessage(message);
  }

  // Get messages
  Stream<MessageSocket> get messages => _socketService.messages;

  // Disconnect
  void disconnect() {
    _socketService.disconnect();
  }
}
