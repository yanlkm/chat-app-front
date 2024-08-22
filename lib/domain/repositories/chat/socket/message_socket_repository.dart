import 'package:either_dart/either.dart';
import 'package:my_app/utils/errors/handlers/socket_error_handler.dart';
import '../../../entities/chat/socket/message_socket_entity.dart';


abstract class MessageSocketRepository {
  Future<Either<SocketErrorHandler, void>> connect(String roomId);
  Future<Either<SocketErrorHandler, void>> sendMessage(MessageSocketEntity message);
  Stream<Either<SocketErrorHandler, MessageSocketEntity>> get messages;
  Future<Either<SocketErrorHandler, void>> disconnect();
}
