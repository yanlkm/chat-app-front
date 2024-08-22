import 'package:either_dart/either.dart';
import 'package:my_app/data/repostiories/chat/db/message_db_repository_impl.dart';
import 'package:my_app/domain/entities/chat/db/message_db_entity.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';

class MessageDBUseCases {
  final MessageDBRepositoryImpl messageDBRepositoryImpl;

  const MessageDBUseCases({
    required this.messageDBRepositoryImpl,
  });

  Future<Either<NetworkErrorHandler, List<MessageDBEntity>>> fetchMessages(String roomId) async {
    return messageDBRepositoryImpl.fetchMessages(roomId);
  }
}