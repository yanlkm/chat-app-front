import 'package:either_dart/either.dart';
import '../../../../data/repositories/chat/socket/message_socket_repository_impl.dart';
import '../../../../utils/errors/handlers/socket_error_handler.dart';
import '../../../entities/chat/socket/message_socket_entity.dart';

//  Message Socket Use Cases
class MessageSocketUseCases {

  // MessageSocketRepositoryImpl instance
  final MessageSocketRepositoryImpl messageSocketRepositoryImpl;

  // Constructor
  const MessageSocketUseCases({
    required this.messageSocketRepositoryImpl,
  });

  // Connect
  Future<Either<SocketErrorHandler, void>> connect(String roomId) async {
    return messageSocketRepositoryImpl.connect(roomId);
  }
  // Send Message
  Future<Either<SocketErrorHandler, void>> sendMessage(MessageSocketEntity message) async {
    return messageSocketRepositoryImpl.sendMessage(message);
  }

  // Disconnect
  Future<Either<SocketErrorHandler, void>> disconnect() async {
    return messageSocketRepositoryImpl.disconnect();
  }

  // Messages
  Stream<Either<SocketErrorHandler, MessageSocketEntity>> get messages async* {
    yield* messageSocketRepositoryImpl.messages;
  }
}
