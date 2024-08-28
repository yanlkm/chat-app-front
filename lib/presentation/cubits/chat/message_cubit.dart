import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat/db/message_db_entity.dart';
import '../../../domain/use_cases/chat/db/message_db_usecases.dart';

// MessageCubit
class MessageCubit extends Cubit<List<MessageDBEntity>> {
  // MessageDBUseCases as attribute
  final MessageDBUseCases messageDBUseCases;

  // Constructor
  MessageCubit(this.messageDBUseCases) : super([]);

  // fetchMessages method
  Future<void> fetchMessages(String roomId) async {
    // fetch messages
    final result = await messageDBUseCases.fetchMessages(roomId);
    result.fold(
      // if error emit []
          (error) => emit([]),
          // if success emit messages
          (messages) => emit(messages),
    );
  }

  // addMessage method
  void addMessage(MessageDBEntity message) {
    emit([...state, message]);
  }
}

