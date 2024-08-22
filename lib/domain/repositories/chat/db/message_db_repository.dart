
import 'package:either_dart/either.dart';
import 'package:my_app/domain/entities/chat/db/message_db_entity.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';

abstract class MessageDBRepository {
  Future<Either<NetworkErrorHandler, List<MessageDBEntity>>> fetchMessages(String roomId);
}