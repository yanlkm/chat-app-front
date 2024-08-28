import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/authentication/token_entity.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';
import 'package:flutter/material.dart';

// SignInState
abstract class SignInState {}

// SignInInitial : initial state
class SignInInitial extends SignInState {
  SignInInitial();
}

// SignInLoading : loading state
class SignInLoading extends SignInState {
  SignInLoading();
}

// SignInLoaded : loaded state
class SignInLoaded extends SignInState {
  SignInLoaded();
}

// SignInSuccess : success state
class SignInSuccess extends SignInState {
  final TokenEntity token;

  SignInSuccess(this.token);
}

// SignInError : error state
class SignInError extends SignInState {
  final String message;

  SignInError(this.message);
}

// SignInCubit : cubit for sign in
class SignInCubit extends Cubit<SignInState> {
  final AuthUseCases authUseCases; // This is the use case that will be used to login

  // Constructor
  SignInCubit(super.initialState, {required this.authUseCases});

  // login method
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
