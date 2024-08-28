
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/data/models/authentication/sign_up/sign_up_model.dart';
import 'package:my_app/data/models/users/user_model.dart';

import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/options_data.dart';
import '../../../utils/data/dio_data.dart';
import '../../../utils/errors/handlers/network_error_handler.dart';
import '../../models/authentication/sign_in/sign_in_model.dart';
import '../../models/authentication/token_model.dart';
import 'auth_data_source.dart';

// This is the implementation of the AuthDataSource
class AuthDataSourceImpl implements AuthDataSource {
  // The required data sources and constants
  final DioData dioData;
  // The secure storage for storing the token
  final FlutterSecureStorage secureStorage;
  // The options data for the headers
  final OptionsData optionsData;
  // The app constants
  final AppConstants appConstants;

  // The constructor
  AuthDataSourceImpl({
    required this.dioData,
    required this.secureStorage,
    required this.optionsData,
    required this.appConstants,
  });

  // The login method to login the user
  @override
  Future<TokenModel> login(SignInModel signInModel) async {
    try {
      // Make a post request to the login endpoint
      final response = await dioData.post(
        '/auth/login',
        data: signInModel.toJson(),
      );
        if (response.statusCode == 200) {
          final token = response.data['token'];
          return TokenModel(token: token);
        } else {
          // If the response is not 200, throw an error
          throw NetworkErrorHandler.fromDioError(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                type: DioExceptionType.badResponse,
              ),
          );
        }
    } catch (e) {
      rethrow;
    }
  }

  // The logout method to logout the user
  @override
  Future<void> logout() async {
    try {
      // Load the options
      final options = await optionsData.loadOptions();
      // Make a get request to the logout endpoint
      final response = await dioData.get(
        '/auth/logout',
        options: options
      );
      if (response.statusCode != 200) {
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      } else {
        return response.data['message'] ?? 'Logout successful';
      }
    } catch(e) {
      rethrow;
    }
  }

  // The register method to register the user
  @override
  Future<UserModel> register(SignUpModel signUpModel) async {
    // Make a post request to the users endpoint
    try {
      final response = await dioData.post(
        '/users',
        data: signUpModel.toJson(),
      );
      // If the response is 200, return the user model
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } catch (e) {
      rethrow;
  }
  }

}
