import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../controllers/authentification/login_controller.dart';
import '../../../cubits/authentication/sign_in/sign_in_cubit.dart';
import '../../../views/authentication/sign_in/sign_in_view.dart';


class SignInPage extends StatelessWidget {
  final LoginController loginController;

  SignInPage({super.key, required this.loginController});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInCubit(
          SignInInitial(),
          loginController: loginController),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign In',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
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
