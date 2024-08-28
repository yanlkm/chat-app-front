import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';

// SignUpState
abstract class SignUpState {
  SignUpState();
}

// SignUpInitial : initial state
class SignUpInitial extends SignUpState {
  SignUpInitial();
}

// SignUpLoading : loading state
class SignUpLoading extends SignUpState {
  SignUpLoading();
}

// SignUpLoaded : loaded state
class SignUpLoaded extends SignUpState {
  SignUpLoaded();
}

// SignUpSuccess : success state
class SignUpSuccess extends SignUpState {
  final UserEntity user;
  final String message;

  SignUpSuccess(this.user, this.message);
}
// SignUpError : error state
class SignUpError extends SignUpState {
  final String message;

  SignUpError(this.message);
}

// SignUpCubit : cubit for sign up
class SignUpCubit extends Cubit<SignUpState> {
  final AuthUseCases authUseCases;

  // Constructor
  SignUpCubit(super.initialState, {required this.authUseCases}) ;

  // register method
  void register(BuildContext context, String username, String password, String passwordConfirmation, String code) async {
    if (username.isEmpty || password.isEmpty || code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    // Check if password and passwordConfirmation match
    if (password != passwordConfirmation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }
    // Register user : call register method from authUseCases
    final eitherUserOrError = await authUseCases.register(username, password, code);
    eitherUserOrError.fold((error) => {
      emit(SignUpError(error.message))
    }, (user) => {
      emit(SignUpSuccess(user, 'User registered successfully. You can now sign in.'))
    }
    );
  }
}
