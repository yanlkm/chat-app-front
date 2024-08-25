import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat/socket/message_socket_entity.dart';
import '../../../domain/use_cases/chat/socket/message_socket_usescases.dart';


class SocketCubit extends Cubit<bool> {
  final MessageSocketUseCases messageSocketUseCases;

  SocketCubit(this.messageSocketUseCases) : super(false);

  Future<void> connectToRoom(String roomId) async {
    final result = await messageSocketUseCases.connect(roomId);
    result.fold(
          (error) => emit(false),
          (_) => emit(true),
    );
  }

  void listenToMessages(Function(MessageSocketEntity) onMessageReceived) {
    messageSocketUseCases.messages.listen((eitherMessage) {
      eitherMessage.fold(
            (error) {
        },
            (message) {
          onMessageReceived(message);
        },
      );
    });
  }

  Future<void> sendMessage(MessageSocketEntity message) async {
    await messageSocketUseCases.sendMessage(message);
  }

  void disconnect() async{
   await messageSocketUseCases.disconnect();
    emit(false);
  }
}