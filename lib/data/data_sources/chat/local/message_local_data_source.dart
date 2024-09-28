
import '../../../models/chat/local/message_local_model.dart';

// MessageLocalDataSource is an abstract class that defines the methods to be implemented by MessageLocalDataSourceImpl
abstract class MessageLocalDataSource {
  // Save a message
  Future<void> saveMessage(MessageLocalModel message);
  // Fetch all messages from a room
  List<MessageLocalModel> fetchLocalMessages(String roomId);
  // update all message by replacing with a new username using userid of message
  Future<void> updateMessage(String userId, String newUsername);
}