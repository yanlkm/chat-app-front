
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/data/models/authentication/sign_up/sign_up_model.dart';
import 'package:my_app/data/models/users/user_model.dart';

import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/options_data.dart';
import '../../../utils/data/dio_data.dart';
import '../../models/authentication/sign_in/sign_in_model.dart';
import '../../models/authentication/token_model.dart';
import 'auth_data_source.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final DioData dioData;
  final FlutterSecureStorage secureStorage;
  final OptionsData optionsData;
  final AppConstants appConstants;


  AuthDataSourceImpl({
    required this.dioData,
    required this.secureStorage,
    required this.optionsData,
    required this.appConstants,
  });

  @override
  Future<TokenModel> login(SignInModel signInModel) async {
    try {
      final response = await dioData.post(
        '/auth/login',
        data: signInModel.toJson(),
      );
        if (response.statusCode == 200) {
          final token = response.data['token'];
          return TokenModel(token: token);
        } else {
          throw response.data['error'] ?? 'Failed to login';
        }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      final options = await optionsData.loadOptions();
      final response = await dioData.post(
        '/auth/logout',
        options: options
      );
      if (response.statusCode != 200) {
        throw response.data['error'] ?? 'Failed to logout';
      } else {
        return response.data['message'] ?? 'Logout successful';
      }
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> register(SignUpModel signUpModel) async {

    try {
      final response = await dioData.post(
        '/auth/register',
        data: signUpModel.toJson(),
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw response.data['error'] ?? 'Failed to register';
      }
    } catch (e) {
      rethrow;
  }
  }

}
