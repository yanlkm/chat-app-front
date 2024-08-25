import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat/db/message_db_entity.dart';
import '../../../domain/use_cases/chat/db/message_db_usecases.dart';


class MessageCubit extends Cubit<List<MessageDBEntity>> {
  final MessageDBUseCases messageDBUseCases;

  MessageCubit(this.messageDBUseCases) : super([]);

  Future<void> fetchMessages(String roomId) async {
    final result = await messageDBUseCases.fetchMessages(roomId);
    result.fold(
          (error) => emit([]),
          (messages) => emit(messages),
    );
  }

  void addMessage(MessageDBEntity message) {
    emit([...state, message]);
  }
}

