import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controllers/chat/socket_controller.dart';
import '../../../models/message_socket.dart';

class SocketCubit extends Cubit<bool> {
  final SocketController socketController;

  SocketCubit(this.socketController) : super(false);

  Future<void> connectToRoom(String roomId) async {
    try {
      await socketController.connectToRoom(roomId);
      emit(true);
    } catch (e) {
      emit(false);
    }
  }

  void listenToMessages(Function(MessageSocket) onMessageReceived) {
    socketController.messages.listen(onMessageReceived);
  }

  void disconnect() {
    socketController.disconnect();
    emit(false);
  }
}
