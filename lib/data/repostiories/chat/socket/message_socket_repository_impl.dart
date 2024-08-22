import 'package:either_dart/either.dart';
import 'package:my_app/utils/errors/handlers/socket_error_handler.dart';

import '../../../../domain/entities/chat/socket/message_socket_entity.dart';
import '../../../../domain/repositories/chat/socket/message_socket_repository.dart';
import '../../../data_sources/chat/socket/message_socket_data_source.dart';
import '../../../models/chat/socket/message_socket_model.dart';


class MessageSocketRepositoryImpl implements MessageSocketRepository {
  final MessageSocketDataSource messageSocketDataSource;

  MessageSocketRepositoryImpl(this.messageSocketDataSource);

  @override
  Future<Either<SocketErrorHandler, void>> connect(String roomId) async {
    try {
      await messageSocketDataSource.connect(roomId);
      return const Right(null);
    } catch (e) {
      return Left(SocketErrorHandler(e.toString()));
    }
  }

  @override
  Future<Either<SocketErrorHandler, void>> sendMessage(MessageSocketEntity message) async {
    try {
      final model = MessageSocketModel(
        roomId: message.roomId,
        username: message.username,
        userId: message.userId,
        message: message.message,
        createdAt: message.createdAt,
      );
      messageSocketDataSource.sendMessage(model);
      return const Right(null);
    } on SocketErrorHandler catch (e) {
      return Left(SocketErrorHandler(e.toString()));
    }
  }

  @override
  Stream<Either<SocketErrorHandler, MessageSocketEntity>> get messages async* {
    await for (final message in messageSocketDataSource.messages) {
      yield Right(message.toEntity());
    }
  }

  @override
  Future<Either<SocketErrorHandler, void>> disconnect() async {
    try {
      await messageSocketDataSource.disconnect();
      return const Right(null);
    }  on SocketErrorHandler catch (e) {
      return Left(SocketErrorHandler(e.toString()));
    }
  }
}
