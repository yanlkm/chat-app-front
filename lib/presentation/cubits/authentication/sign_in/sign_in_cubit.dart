import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/authentication/token_entity.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';
import 'package:flutter/material.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {
  SignInInitial();
}

class SignInLoading extends SignInState {
  SignInLoading();
}

class SignInLoaded extends SignInState {
  SignInLoaded();
}

class SignInSuccess extends SignInState {
  final TokenEntity token;

  SignInSuccess(this.token);
}

class SignInError extends SignInState {
  final String message;

  SignInError(this.message);
}

class SignInCubit extends Cubit<SignInState> {
  final AuthUseCases authUseCases; // This is the use case that will be used to login

  SignInCubit(super.initialState, {required this.authUseCases});

  void login(BuildContext context, String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }
    final eitherTokenOrError = await authUseCases.login(username, password);
    eitherTokenOrError.fold(
      (error) => emit(SignInError(error.message)),
      (token) => emit(SignInSuccess(token)),
    );

  }
}
