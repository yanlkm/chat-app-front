
import '../../models/message.dart';
import '../../services/chat/message_service.dart';

class MessageController {
  // Create an instance of the service
  final MessageService _messageService = MessageService();

  // Constructor
  Future<List<Message>> getMessages(String roomId) async {
    return await _messageService.fetchMessages(roomId);
  }
}
