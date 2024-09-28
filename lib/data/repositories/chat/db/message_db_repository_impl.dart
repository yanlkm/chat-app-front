import 'package:either_dart/either.dart';
import 'package:my_app/data/data_sources/chat/db/message_db_data_source_impl.dart';
import 'package:my_app/data/data_sources/chat/local/message_local_data_source_impl.dart';
import 'package:my_app/data/models/chat/db/message_db_model.dart';
import 'package:my_app/data/models/chat/local/message_local_model.dart';
import 'package:my_app/domain/entities/chat/db/message_db_entity.dart';
import 'package:my_app/domain/repositories/chat/db/message_db_repository.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';

// Message DB Repository Implementation
class MessageDBRepositoryImpl implements MessageDBRepository {
  // Message DB Remote Data Source
  final MessageDBDataSourceImpl messageDBRemoteDataSource;

  // Message Local Data Source
  final MessageLocalDataSourceImpl messageLocalDataSourceImpl;

  // Constructor
  const MessageDBRepositoryImpl(this.messageDBRemoteDataSource, this.messageLocalDataSourceImpl);

  // Fetch Remote Messages implementation : Future<Either<NetworkErrorHandler, List<MessageDBEntity>>>
  @override
  Future<Either<NetworkErrorHandler, List<MessageDBEntity>>> fetchRemoteMessages(
      String roomId) async {
    try {
      //  Fetch messages
      final List<MessageDBModel> messagesDBModel = await messageDBRemoteDataSource.fetchMessages(roomId);
      // Map messages to entities
      final List<MessageDBEntity> messageDBEntities = messagesDBModel.map( (message) =>  message.toEntity()).toList();
      // Return messages entities
      return Right<NetworkErrorHandler, List<MessageDBEntity>>(messageDBEntities);
    } on NetworkErrorHandler catch(e)
    {
      // Catch error if any error occurs
      return  Left<NetworkErrorHandler, List<MessageDBEntity>>(e);
    }
  }

  // Fetch Local Messages implementation : Future<Either<NetworkErrorHandler, List<MessageDBEntity>>>
  @override
  Future<Either<NetworkErrorHandler, List<MessageDBEntity>>> fetchLocalMessages(String roomId) async {
    try {
      // Fetch local messages
      final List<MessageLocalModel> messagesDBModel = messageLocalDataSourceImpl.fetchLocalMessages(roomId);
      // Map messages to entities
      final List<MessageDBEntity> messageDBEntities = messagesDBModel.map( (message) =>  message.toEntity()).toList();
      // Return messages entities
      return Right<NetworkErrorHandler, List<MessageDBEntity>>(messageDBEntities);
    } on NetworkErrorHandler catch(e)
    {
      // Catch error if any error occurs
      return  Left<NetworkErrorHandler, List<MessageDBEntity>>(e);
    }

  }

  // Save Message implementation : Future<Either<NetworkErrorHandler, void>>
  @override
  Future<Either<NetworkErrorHandler, void>> saveMessage(MessageDBEntity message) async {
    try {
      // Save message
      await messageLocalDataSourceImpl.saveMessage(
          MessageLocalModel(
            messageID: message.messageID ?? '',
            roomID: message.roomID ?? '',
            username: message.username ?? '',
            userId: message.userId ?? '',
            content: message.content ?? '',
            createdAt: message.createdAt.toString(),
          )
      );
      // Return void
      return const Right<NetworkErrorHandler, void>(null);
    } on NetworkErrorHandler catch(e)
    {
      // Catch error if any error occurs
      return  Left<NetworkErrorHandler, void>(e);
    }

  }

  @override
  Future<Either<NetworkErrorHandler, void>> updateMessage(String userId, String newUsername) {

    throw UnimplementedError();
  }
}
