import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';

class BasePageCubit extends Cubit<void> {
final AuthUseCases authUseCases;

  BasePageCubit({required this.authUseCases}) : super(null);

  Future<void> logoutUser() async {
    final eitherSuccessOrError = await authUseCases.logout();
    eitherSuccessOrError.fold((error) => emit(null), (success) => emit(null));
  }
}
