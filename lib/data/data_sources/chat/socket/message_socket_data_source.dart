
import '../../../models/chat/socket/message_socket_model.dart';

abstract class MessageSocketDataSource {
  Future<void> connect(String roomId);
  void sendMessage(MessageSocketModel message);
  Stream<MessageSocketModel> get messages;
  Future<void> disconnect();
}
