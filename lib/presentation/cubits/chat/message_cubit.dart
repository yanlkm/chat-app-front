import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat/db/message_db_entity.dart';
import '../../../domain/use_cases/chat/db/message_db_usecases.dart';


class MessageCubit extends Cubit<List<MessageDBEntity>> {
  final MessageDBUseCases messageDBUseCases;

  MessageCubit(this.messageDBUseCases) : super([]);

  // fetchMessages method to handle both local and remote messages
  Future<void> fetchMessages(String roomId) async {
    // Fetch local messages first
    final localResult = await messageDBUseCases.fetchLocalMessages(roomId);
    localResult.fold(
          (error) => {
          _fetchRemoteMessages(roomId, [])
    },
          (localMessages) {
        emit(localMessages);
        _fetchRemoteMessages(roomId, localMessages);
      },
    );
  }

  // Fetch remote messages and filter out the new ones
  Future<void> _fetchRemoteMessages(String roomId, List<MessageDBEntity> localMessages) async {
    final remoteResult = await messageDBUseCases.fetchRemoteMessages(roomId);
    remoteResult.fold(
          (error) => emit(state), // Keep the local messages in case of error
          (remoteMessages) {
              // Filter out messages already present locally by comparing if they are the same
              final newMessages = remoteMessages.where((remoteMsg) =>
              !localMessages.any((localMsg) =>
                  areMessagesTheSame(localMsg, remoteMsg),
              )
              ).toList();
              // Save new messages locally
              for (var message in newMessages) {
                messageDBUseCases.saveMessage(message);
              }
              // update messages locally
              updateMessage(roomId);
              // Update the state with the new messages
              emit([...state, ...newMessages]);
          },
    );
  }

  // add message in chat
  void addMessage(MessageDBEntity message) async {
    // save message if not already saved
    bool isAlreadySave = false;
    final localResult = await messageDBUseCases.fetchLocalMessages(message.roomID!);
    localResult.fold(
          (error) => emit([]),
          (localMessages) {
        // if the message is not the same with all messages stored, we save it
        for (var localMessage in localMessages) {
          isAlreadySave = areMessagesTheSame(localMessage, message);
        }
        // we save message if not saved yet
        if (isAlreadySave) {
          messageDBUseCases.saveMessage(message);
          emit([...state, message]);
        }
      },
    );
  }

  // function to compare two MessageDBEntities
  bool areMessagesTheSame(MessageDBEntity firstMessage, MessageDBEntity secondMessage) {
    return firstMessage.content == firstMessage.content && firstMessage.userId == secondMessage.userId &&
        isSameTime(firstMessage.createdAt!, firstMessage.createdAt!);
  }

  // function to check if two datetime have less than 10 seconds difference
  bool isSameTime(DateTime time1, DateTime time2) {
    return time1.difference(time2).inSeconds.abs() < 10;
  }

  // update messages locally using fetch remote messages
  void updateMessage(String roomId) async {
    // Fetch remote messages
    final remoteResult = await messageDBUseCases.fetchRemoteMessages(roomId);
    remoteResult.fold(
          (error) => {},
          (remoteMessages) {
            // Update messages locally
        for (var remoteMessage in remoteMessages) {
          messageDBUseCases.updateMessage(remoteMessage.userId!, remoteMessage.username!);
        }
      },
    );
  }
}

