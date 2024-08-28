import 'package:either_dart/either.dart';
import 'package:my_app/data/data_sources/chat/db/message_db_data_source_impl.dart';
import 'package:my_app/data/models/chat/db/message_db_model.dart';
import 'package:my_app/domain/entities/chat/db/message_db_entity.dart';
import 'package:my_app/domain/repositories/chat/db/message_db_repository.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';

// Message DB Repository Implementation
class MessageDBRepositoryImpl implements MessageDBRepository {
  // Message DB Remote Data Source
  final MessageDBDataSourceImpl messageDBRemoteDataSource;
  // Constructor
  const MessageDBRepositoryImpl(this.messageDBRemoteDataSource);

  // Fetch Messages implementation : Future<Either<NetworkErrorHandler, List<MessageDBEntity>>>
  @override
  Future<Either<NetworkErrorHandler, List<MessageDBEntity>>> fetchMessages(
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
}
