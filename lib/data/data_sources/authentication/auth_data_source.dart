import '../../models/authentication/sign_in/sign_in_model.dart';
import '../../models/authentication/sign_up/sign_up_model.dart';
import '../../models/authentication/token_model.dart';
import '../../models/users/user_model.dart';

// This is the abstract class for the authentication data source
abstract class AuthDataSource {
  // This method is used to login the user
  Future<TokenModel> login(SignInModel signInModel);
  // This method is used to logout the user
  Future<void> logout();
  // This method is used to register the user
  Future<UserModel> register(SignUpModel signUpModel);
}
