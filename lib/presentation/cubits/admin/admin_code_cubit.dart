

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controllers/user/user_controller.dart';

class AdminCodeCubit extends Cubit<String> {
  final UserController userController;

  AdminCodeCubit(this.userController) : super('');

  Future<void> createCode(String code) async {
    try {
      String generatedCode = await userController.createRegistrationCode(code);
      emit(generatedCode);
    } catch (e) {
      emit('Error: Failed to create code');
    }
  }
}
