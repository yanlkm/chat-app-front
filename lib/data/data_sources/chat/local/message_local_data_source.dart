
import '../../../models/chat/local/message_local_model.dart';

abstract class MessageLocalDataSource {
  Future<void> saveMessage(MessageLocalModel message);
  List<MessageLocalModel> fetchLocalMessages(String roomId);
  Future<void> updateMessage(String userId, String newUsername);
}