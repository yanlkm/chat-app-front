import 'package:either_dart/either.dart';
import 'package:my_app/utils/errors/handlers/socket_error_handler.dart';

import '../../../../domain/entities/chat/socket/message_socket_entity.dart';
import '../../../../domain/repositories/chat/socket/message_socket_repository.dart';
import '../../../data_sources/chat/socket/message_socket_data_source.dart';
import '../../../models/chat/socket/message_socket_model.dart';

// Message Socket Repository Implementation
class MessageSocketRepositoryImpl implements MessageSocketRepository {
  // Message Socket Data Source
  final MessageSocketDataSource messageSocketDataSource;
  // Constructor
  MessageSocketRepositoryImpl(this.messageSocketDataSource);

  // Connect implementation : Future<Either<SocketErrorHandler, void>>
  @override
  Future<Either<SocketErrorHandler, void>> connect(String roomId) async {
    try {
      // Connect to socket
      await messageSocketDataSource.connect(roomId);
      // Return null if successful
      return const Right(null);
    } catch (e) {
      // Catch error if any error occurs
      return Left(SocketErrorHandler(e.toString()));
    }
  }

  // Send Message implementation : Future<Either<SocketErrorHandler, void>>
  @override
  Future<Either<SocketErrorHandler, void>> sendMessage(MessageSocketEntity message) async {
    try {
      // Create MessageSocketModel
      final model = MessageSocketModel(
        roomId: message.roomId,
        username: message.username,
        userId: message.userId,
        message: message.message,
        createdAt: message.createdAt,
      );
      // Send message
      messageSocketDataSource.sendMessage(model);
      // Return null if successful
      return const Right(null);
    } on SocketErrorHandler catch (e) {
      // Catch error if any error occurs
      return Left(SocketErrorHandler(e.toString()));
    }
  }

  // Get Messages implementation : Stream<Either<SocketErrorHandler, MessageSocketEntity>>
  @override
  Stream<Either<SocketErrorHandler, MessageSocketEntity>> get messages async* {
    // Get messages
    await for (final message in messageSocketDataSource.messages) {
      // Yield message entity
      yield Right(message.toEntity());
    }
  }

  // Disconnect implementation : Future<Either<SocketErrorHandler, void>>
  @override
  Future<Either<SocketErrorHandler, void>> disconnect() async {
    try {
      // Disconnect if successful
      await messageSocketDataSource.disconnect();
      // Return null if successful
      return const Right(null);
    }  on SocketErrorHandler catch (e) {
      // Catch error if any error occurs
      return Left(SocketErrorHandler(e.toString()));
    }
  }
}
