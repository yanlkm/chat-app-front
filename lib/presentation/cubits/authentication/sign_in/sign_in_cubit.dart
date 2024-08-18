import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../controllers/authentification/login_controller.dart';
import 'package:flutter/material.dart';

class SignInCubit extends Cubit<void> {
  final LoginController loginController;

  SignInCubit({required this.loginController}) : super(null);

  void login(BuildContext context, String username, String password) {
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }
    loginController.login(context, username, password);
  }
}
