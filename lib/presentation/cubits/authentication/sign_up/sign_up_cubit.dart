import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../controllers/authentification/register_controller.dart';

class SignUpCubit extends Cubit<void> {
  final RegisterController registerController;

  SignUpCubit({required this.registerController}) : super(null);

  void register(BuildContext context, String username, String password, String passwordConfirmation, String code) {
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

    registerController.register(context, username, password, code);
  }
}
