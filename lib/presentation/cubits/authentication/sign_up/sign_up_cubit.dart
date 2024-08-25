import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';

abstract class SignUpState {
  SignUpState();
}

class SignUpInitial extends SignUpState {
  SignUpInitial();
}

class SignUpLoading extends SignUpState {
  SignUpLoading();
}

class SignUpLoaded extends SignUpState {
  SignUpLoaded();
}

class SignUpSuccess extends SignUpState {
  final UserEntity user;
  final String message;

  SignUpSuccess(this.user, this.message);
}

class SignUpError extends SignUpState {
  final String message;

  SignUpError(this.message);
}

class SignUpCubit extends Cubit<SignUpState> {
  final AuthUseCases authUseCases;

  SignUpCubit(super.initialState, {required this.authUseCases}) ;

  void register(BuildContext context, String username, String password, String passwordConfirmation, String code) async {
    if (username.isEmpty || password.isEmpty || code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    if (password != passwordConfirmation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }
    final eitherUserOrError = await authUseCases.register(username, password, code);
    eitherUserOrError.fold((error) => {
      emit(SignUpError(error.message))
    }, (user) => {
      emit(SignUpSuccess(user, 'User registered successfully. You can now sign in.'))
    }
    );
  }
}
