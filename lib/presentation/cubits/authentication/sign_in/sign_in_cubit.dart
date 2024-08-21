import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/models/utils/error.dart';
import 'package:my_app/models/utils/token.dart';
import '../../../../controllers/authentification/login_controller.dart';
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
  final Token token;

  SignInSuccess(this.token);
}

class SignInError extends SignInState {
  final String message;

  SignInError(this.message);
}

class SignInCubit extends Cubit<SignInState> {
  final LoginController loginController;

  SignInCubit(super.initialState, {required this.loginController});

  void login(BuildContext context, String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }
    final response = await loginController.login(context, username, password);

    if (response is Token)
    {
      emit(SignInSuccess(response));
    }
    else if (response is ErrorResponse) {
      emit(SignInError(response.error));
    }
  }
}
