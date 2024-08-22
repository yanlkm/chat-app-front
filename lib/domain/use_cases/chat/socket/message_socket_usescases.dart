import 'package:either_dart/either.dart';
import '../../../../data/repostiories/chat/socket/message_socket_repository_impl.dart';
import '../../../../utils/errors/handlers/socket_error_handler.dart';
import '../../../entities/chat/socket/message_socket_entity.dart';

class MessageSocketUseCases {

  final MessageSocketRepositoryImpl messageSocketRepositoryImpl;

  const MessageSocketUseCases({
    required this.messageSocketRepositoryImpl,
  });

  Future<Either<SocketErrorHandler, void>> connect(String roomId) async {
    return messageSocketRepositoryImpl.connect(roomId);
  }

  Future<Either<SocketErrorHandler, void>> sendMessage(MessageSocketEntity message) async {
    return messageSocketRepositoryImpl.sendMessage(message);
  }

  Stream<Either<SocketErrorHandler, MessageSocketEntity>> get messages async* {
    yield* messageSocketRepositoryImpl.messages;
  }
}
