import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat/socket/message_socket_entity.dart';
import '../../../domain/use_cases/chat/socket/message_socket_usescases.dart';

// SocketCubit
class SocketCubit extends Cubit<bool> {
  // MessageSocketUseCases as attribute
  final MessageSocketUseCases messageSocketUseCases;

  // Constructor
  SocketCubit(this.messageSocketUseCases) : super(false);

  // connectToRoom method
  Future<void> connectToRoom(String roomId) async {
    // connect to room
    final result = await messageSocketUseCases.connect(roomId);
    result.fold(
          // if error emit false
          (error) => emit(false),
          // if success emit true
          (_) => emit(true),
    );
  }

  // listenToMessages method
  void listenToMessages(Function(MessageSocketEntity) onMessageReceived) {
    messageSocketUseCases.messages.listen((eitherMessage) {
      eitherMessage.fold(
            (error) {
        },
        // if success onMessageReceived
            (message) {
          onMessageReceived(message);
        },
      );
    });
  }

  // sendMessage method
  Future<void> sendMessage(MessageSocketEntity message) async {
    await messageSocketUseCases.sendMessage(message);
  }

  // disconnect method
  void disconnect() async{
   await messageSocketUseCases.disconnect();
    emit(false);
  }
}