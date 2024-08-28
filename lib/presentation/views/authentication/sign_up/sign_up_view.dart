import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_widgets/authentication/sign_in/password_input_widget.dart';
import '../../../_widgets/authentication/sign_in/username_input_widget.dart';
import '../../../_widgets/authentication/sign_up/code_input_widget.dart';
import '../../../_widgets/authentication/sign_up/password_confirmation_input_widget.dart';
import '../../../_widgets/authentication/sign_up/sign_up_button_widget.dart';
import '../../../cubits/authentication/sign_up/sign_up_cubit.dart';

// SignUpView : sign up view
class SignUpView extends StatelessWidget {
  // attributes : text controllers
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  final TextEditingController codeController;

  // Constructor
  const SignUpView({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.codeController,
  });

  // build method
  @override
  Widget build(BuildContext context) {
    // BlocConsumer : consumer for SignUpCubit - listen to the state changes
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        // Display success message or handle errors
        if (state is SignUpSuccess) {
          // clean up the text fields
          usernameController.clear();
          passwordController.clear();
          passwordConfirmationController.clear();
          codeController.clear();
          // Display a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          // push to the sign in page
          Navigator.pushNamed(context, '/signing');
        } else if (state is SignUpError) {
          // Error handling with a red Scaffold will be done in the builder
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // UsernameTextField : username input field
                // PasswordTextField : password input field
                // PasswordConfirmationTextField : password confirmation input field
                // CodeTextField : code input field
                // SignUpButton : sign up button
                const SizedBox(height: 20.0),
                UsernameTextField(usernameController: usernameController),
                const SizedBox(height: 20.0),
                PasswordTextField(passwordController: passwordController),
                const SizedBox(height: 20.0),
                PasswordConfirmationTextField(
                  passwordConfirmationController: passwordConfirmationController,
                ),
                const SizedBox(height: 20.0),
                CodeTextField(codeController: codeController),
                const SizedBox(height: 20.0),
                // treat the state : if SignUpLoading : display a circular progress indicator, if not : display the sign up button
                if (state is SignUpLoading)
                  const Center(child: CircularProgressIndicator()),
                if (state is! SignUpLoading)
                  SignUpButton(
                    onPressed: () {
                      context.read<SignUpCubit>().register(
                        context,
                        usernameController.text,
                        passwordController.text,
                        passwordConfirmationController.text,
                        codeController.text,
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
