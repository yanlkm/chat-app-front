import 'package:objectbox/objectbox.dart';
import '../../../../objectbox.g.dart';
import '../../../models/chat/local/message_local_model.dart';
import 'message_local_data_source.dart';

// MessageLocalDataSourceImpl is a class that implements the MessageLocalDataSource
class MessageLocalDataSourceImpl implements MessageLocalDataSource {
  final Box<MessageLocalModel> _messageBox;

  MessageLocalDataSourceImpl(this._messageBox);

  // Save a message
  @override
  Future<void> saveMessage(MessageLocalModel message) async {
    _messageBox.put(message);
  }

  // Fetch all messages from a room
  @override
  List<MessageLocalModel> fetchLocalMessages(String roomId) {
    return _messageBox.query(MessageLocalModel_.roomID.equals(roomId))
        .build()
        .find();
  }

  // update all message by replacing with a new username using userid of message
  @override
  Future<void> updateMessage(String userId, String newUsername) async {
    // Fetch all messages with the given userId
    final messages = _messageBox.query(MessageLocalModel_.userId.equals(userId)).build().find();
    // Update the username of all messages
    for (var message in messages) {
      message.username = newUsername;
      _messageBox.put(message);
    }
  }
}
