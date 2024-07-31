import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controllers/user/user_controller.dart';

abstract class PasswordState {}

class PasswordInitial extends PasswordState {}

class PasswordLoading extends PasswordState {}

class PasswordUpdated extends PasswordState {
  final String message;

  PasswordUpdated(this.message);
}

class PasswordError extends PasswordState {
  final String message;

  PasswordError(this.message);
}

class PasswordCubit extends Cubit<PasswordState> {
  final UserController userController;

  PasswordCubit(this.userController) : super(PasswordInitial());

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    emit(PasswordLoading());
    try {
      //TODO: Call the update password service modified
      final result = await userController.updatePassword(oldPassword, newPassword);
      if (result == 'Password updated successfully') {
        emit(PasswordUpdated(result));
      } else {
        emit(PasswordError(result));
      }
    } catch (e) {
      emit(PasswordError(e.toString()));
    }
  }
}