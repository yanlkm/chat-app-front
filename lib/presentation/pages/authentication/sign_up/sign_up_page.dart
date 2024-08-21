import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controllers/authentification/register_controller.dart';
import '../../../cubits/authentication/sign_up/sign_up_cubit.dart';
import '../../../views/authentication/sign_up/sign_up_view.dart';

class SignUpPage extends StatelessWidget {
  final RegisterController registerController;

  SignUpPage({super.key, required this.registerController});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(
        SignUpInitial(),
        registerController: registerController,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: BlocBuilder<SignUpCubit, void>(
          builder: (context, state) {
            return SignUpView(
              usernameController: _usernameController,
              passwordController: _passwordController,
              passwordConfirmationController: _passwordConfirmationController,
              codeController: _codeController,
            );
          },
        ),
      ),
    );
  }
}
