
import '../../../models/chat/socket/message_socket_model.dart';

// This is the abstract class for the MessageSocketDataSource
abstract class MessageSocketDataSource {
  // This method is used to connect to the socket
  Future<void> connect(String roomId);
  // This method is used to send a message to the socket
  void sendMessage(MessageSocketModel message);
  // This method is used to get the messages from the socket
  Stream<MessageSocketModel> get messages;
  // This method is used to disconnect from the socket
  Future<void> disconnect();
}
