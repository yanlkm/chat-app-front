import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/use_cases/users/user_usecases.dart';

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
  final UserUseCases userUseCases;

  PasswordCubit(this.userUseCases) : super(PasswordInitial());

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    emit(PasswordLoading());
    try {
      final result = await userUseCases.updatePassword(oldPassword, newPassword);

      result.fold(
        (error) => emit(PasswordError(error.message)),
        (message) => emit(PasswordUpdated(message)),
      );
    } catch (e) {
      emit(PasswordError(e.toString()));
    }
  }
}