
import 'package:my_app/data/models/chat/db/message_db_model.dart';

// MessageDBDataSource is an abstract class that defines the methods that any class
abstract class MessageDBDataSource {
  // get all messages from a Room
  Future<List<MessageDBModel>> fetchMessages(String roomId);
}