import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../_widgets/authentication/sign_in/password_input_widget.dart';
import '../../../_widgets/authentication/sign_in/sign_in_button_widget.dart';
import '../../../_widgets/authentication/sign_in/username_input_widget.dart';
import '../../../cubits/authentication/sign_in/sign_in_cubit.dart';

// SignInView : sign in view
class SignInView extends StatelessWidget {
  // attributes
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  // callbacks
  final VoidCallback onSignInPressed;
  final VoidCallback onSignUpPressed;

  // Constructor
  const SignInView({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.onSignInPressed,
    required this.onSignUpPressed,
  });

  // build method
  @override
  Widget build(BuildContext context) {
    // BlocConsumer : consumer for SignInCubit - listen to the state changes
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) async {
        if (state is SignInError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
          // if state is SignInSuccess : treat the token response
        } else if (state is SignInSuccess) {
          // treat the token response
          var token = state.token.token;
          // store token in secure storage
          const secureStorage = FlutterSecureStorage();
          await secureStorage.write(key :'token', value : token);
          // decode the token
          Map<String, dynamic> jwt = JwtDecoder.decode(token);
          // store the user id in secure storage
          await secureStorage.write(key : 'userId', value : jwt['_id']);
          // store the username in secure storage
          await secureStorage.write(key : 'username', value:  jwt['Username']);
          // store the user role in secure storage
          await secureStorage.write(key : 'role', value: jwt['Role']);
          // display a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome back ${jwt['Username']} !!'),
              backgroundColor: Colors.green,
            ),
          );
          // redirect to home page
          Navigator.pushNamed(context, '/home');
        }
      },
      // builder for SignInCubit
      builder: (context, state) {
        return Scaffold(

          body: SingleChildScrollView(
            // padding: const EdgeInsets.all(20.0), // (1
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // treat the state : if SignInLoading : display a circular progress indicator, if not : display the username input field
                if(state is SignInLoading)
                  const Center(child: CircularProgressIndicator()),
                if(state is! SignInLoading)
                UsernameTextField(usernameController: usernameController),
                const SizedBox(height: 20.0),
                PasswordTextField(passwordController: passwordController),
                const SizedBox(height: 20.0),
                SignInButton(onPressed: onSignInPressed),
                const SizedBox(height: 20.0, width: 20.0),
                TextButton(
                  onPressed: onSignUpPressed,
                  child: const Text(
                    'Don\'t have an account? Sign Up',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
        )
        );
      },
    );
  }
}

