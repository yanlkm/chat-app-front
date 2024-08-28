import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/use_cases/users/user_usecases.dart';

// AdminCodeCubit
class AdminCodeCubit extends Cubit<String> {
  // UserUseCases as attribute
  final UserUseCases userUseCases;

  // Constructor
  AdminCodeCubit(this.userUseCases) : super('');

  // createCode method
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
