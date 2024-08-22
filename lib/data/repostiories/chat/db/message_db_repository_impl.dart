import 'package:either_dart/either.dart';
import 'package:my_app/data/data_sources/chat/db/message_db_data_source_impl.dart';
import 'package:my_app/data/models/chat/db/message_db_model.dart';
import 'package:my_app/domain/entities/chat/db/message_db_entity.dart';
import 'package:my_app/domain/repositories/chat/db/message_db_repository.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';

class MessageDBRepositoryImpl implements MessageDBRepository {
  final MessageDBDataSourceImpl messageDBRemoteDataSource;

  const MessageDBRepositoryImpl(this.messageDBRemoteDataSource);

  @override
  Future<Either<NetworkErrorHandler, List<MessageDBEntity>>> fetchMessages(
      String roomId) async {
    try {
      final List<MessageDBModel> messagesDBModel = await messageDBRemoteDataSource.fetchMessages(roomId);
      final List<MessageDBEntity> messageDBEntities = messagesDBModel.map( (message) =>  message.toEntity()).toList();
      return Right<NetworkErrorHandler, List<MessageDBEntity>>(messageDBEntities);
    } on NetworkErrorHandler catch(e)
    {
      return  Left<NetworkErrorHandler, List<MessageDBEntity>>(e);
    }
  }
}
