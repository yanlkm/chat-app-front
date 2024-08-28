import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';

// BasePageCubit
class BasePageCubit extends Cubit<void> {
  // AuthUseCases as attribute
final AuthUseCases authUseCases;

  // Constructor
  BasePageCubit({required this.authUseCases}) : super(null);

  // logoutUser method
  Future<void> logoutUser() async {
    final eitherSuccessOrError = await authUseCases.logout();
    eitherSuccessOrError.fold((error) => emit(null), (success) => emit(null));
  }
}
