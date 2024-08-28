import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/use_cases/users/user_usecases.dart';

// PasswordState
abstract class PasswordState {}

// PasswordInitial : initial state
class PasswordInitial extends PasswordState {}

// PasswordLoading : loading state
class PasswordLoading extends PasswordState {}

// PasswordUpdated : updated state
class PasswordUpdated extends PasswordState {
  final String message;

  PasswordUpdated(this.message);
}

// PasswordError : error state
class PasswordError extends PasswordState {
  final String message;

  PasswordError(this.message);
}

// PasswordCubit : cubit for password
class PasswordCubit extends Cubit<PasswordState> {
  final UserUseCases userUseCases;

  // Constructor
  PasswordCubit(this.userUseCases) : super(PasswordInitial());

  // updatePassword method
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