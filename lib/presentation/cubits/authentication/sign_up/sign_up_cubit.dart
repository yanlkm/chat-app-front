import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../controllers/authentification/register_controller.dart';
import '../../../../models/user.dart';
import '../../../../models/utils/error.dart';

abstract class SignUpState {}

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
  final User user;
  final String message;

  SignUpSuccess(this.user, this.message);
}

class SignUpError extends SignUpState {
  final String message;

  SignUpError(this.message);
}

class SignUpCubit extends Cubit<SignUpState> {
  final RegisterController registerController;

  SignUpCubit(super.initialState, {required this.registerController}) ;

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
    final response = await registerController.register(
        context, username, password, code);

    if (response is User) {
      emit(SignUpSuccess(response, 'User registered successfully. You can now sign in.'));
    } else
    if(response is ErrorResponse) {
      {
        emit(SignUpError(response.error));
      }
    }

  }
}
