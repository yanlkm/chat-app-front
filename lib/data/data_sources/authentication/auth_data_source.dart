import '../../models/authentication/sign_in/sign_in_model.dart';
import '../../models/authentication/sign_up/sign_up_model.dart';
import '../../models/authentication/token_model.dart';
import '../../models/users/user_model.dart';

abstract class AuthDataSource {
  Future<TokenModel> login(SignInModel signInModel);
  Future<void> logout();
  Future<UserModel> register(SignUpModel signUpModel);
}
