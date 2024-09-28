
import 'package:either_dart/either.dart';
import 'package:my_app/domain/entities/chat/db/message_db_entity.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';
// Message DB Repository
abstract class MessageDBRepository {
  // Fetch Remote Messages
  Future<Either<NetworkErrorHandler, List<MessageDBEntity>>> fetchRemoteMessages(String roomId);
  // Fetch Local Messages
  Future<Either<NetworkErrorHandler, List<MessageDBEntity>>> fetchLocalMessages(String roomId);
  // Save Message
  Future<Either<NetworkErrorHandler, void>> saveMessage(MessageDBEntity message);
  // update Message Locally
  Future<Either<NetworkErrorHandler, void>> updateMessage(String userId, String newUsername);
}