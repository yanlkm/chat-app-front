import 'package:either_dart/either.dart';
import 'package:my_app/data/repositories/chat/db/message_db_repository_impl.dart';
import 'package:my_app/domain/entities/chat/db/message_db_entity.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';

// Message DB Use Cases
class MessageDBUseCases {
  final MessageDBRepositoryImpl messageDBRepositoryImpl;

  // Constructor
  const MessageDBUseCases({
    required this.messageDBRepositoryImpl,
  });

  // Fetch Remote Messages
  Future<Either<NetworkErrorHandler, List<MessageDBEntity>>> fetchRemoteMessages(String roomId) async {
    return messageDBRepositoryImpl.fetchRemoteMessages(roomId);
  }
  //  Fetch Local Messages
  Future<Either<NetworkErrorHandler, List<MessageDBEntity>>> fetchLocalMessages(String roomId) async {
    return messageDBRepositoryImpl.fetchLocalMessages(roomId);
  }
  // Save Message
  Future<Either<NetworkErrorHandler, void>> saveMessage(MessageDBEntity message) async {
    return messageDBRepositoryImpl.saveMessage(message);
  }
}