
import 'package:my_app/data/models/chat/db/message_db_model.dart';

abstract class MessageDBDataSource {
  // get all messages from a Room
  Future<List<MessageDBModel>> fetchMessages(String roomId);
}