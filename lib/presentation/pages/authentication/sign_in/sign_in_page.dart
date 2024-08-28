import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';
import '../../../cubits/authentication/sign_in/sign_in_cubit.dart';
import '../../../views/authentication/sign_in/sign_in_view.dart';

// SignInPage : sign in page entry point
class SignInPage extends StatelessWidget {
  // UseCases
  final AuthUseCases authUseCases;

  // Constructor
  SignInPage({super.key, required this.authUseCases});

  // initialize text controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // build method
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // create SignInCubit : cubit for sign in
      create: (_) => SignInCubit(SignInInitial(), authUseCases: authUseCases),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign In',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        // BlocBuilder : builder for SignInCubit
        body: BlocBuilder<SignInCubit, void>(
          builder: (context, state) {
            return SignInView(
              usernameController: _usernameController,
              passwordController: _passwordController,
              onSignInPressed: () {
                context.read<SignInCubit>().login(
                      context,
                      _usernameController.text,
                      _passwordController.text,
                    );
              },
              onSignUpPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
            );
          },
        ),
      ),
    );
  }
}
