import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/use_cases/authentication/auth_usecases.dart';
import '../../../cubits/authentication/sign_up/sign_up_cubit.dart';
import '../../../views/authentication/sign_up/sign_up_view.dart';

// SignUpPage : sign up page entry point
class SignUpPage extends StatelessWidget {
  // UseCases
  final AuthUseCases authUseCases;

  // Constructor
  SignUpPage({super.key, required this.authUseCases});

  // initialize text controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  // build method
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // create SignUpCubit : cubit for sign up
      create: (_) => SignUpCubit(
        SignUpInitial(),
        authUseCases: authUseCases,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        // BlocBuilder : builder for SignUpCubit
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
