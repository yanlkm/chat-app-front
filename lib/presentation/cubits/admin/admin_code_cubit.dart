import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/use_cases/users/user_usecases.dart';

class AdminCodeCubit extends Cubit<String> {
  final UserUseCases userUseCases;

  AdminCodeCubit(this.userUseCases) : super('');

  Future<void> createCode(String code) async {
    try {
      final eitherSuccessorError = await userUseCases.createRegistrationCode(code);
      eitherSuccessorError.fold((error) => emit(error.message), (generatedCode) =>
      emit(generatedCode));
    } catch (e) {
      emit('Error: Failed to create code');
    }
  }
}
