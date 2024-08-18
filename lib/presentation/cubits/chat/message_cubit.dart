import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controllers/chat/message_controller.dart';
import '../../../models/message.dart';


class MessageCubit extends Cubit<List<Message>> {
  final MessageController messageController;

  MessageCubit(this.messageController) : super([]);

  Future<void> fetchMessages(String roomId) async {
    try {
      final messages = await messageController.getMessages(roomId);
      emit(messages);
    } catch (e) {
      emit([]);
    }
  }

  void addMessage(Message message) {
    emit([...state, message]);
  }
}
