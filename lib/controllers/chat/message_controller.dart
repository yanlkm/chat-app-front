
import '../../models/message.dart';
import '../../services/chat/message_service.dart';

class MessageController {
  final MessageService _messageService = MessageService();

  Future<List<Message>> getMessages(String roomId) async {
    return await _messageService.fetchMessages(roomId);
  }
}
