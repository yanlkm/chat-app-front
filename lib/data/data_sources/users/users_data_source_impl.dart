
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/data/data_sources/users/users_data_source.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/options_data.dart';
import '../../../utils/data/dio_data.dart';
import '../../../utils/errors/handlers/network_error_handler.dart';
import '../../models/users/user_model.dart';

// Users Data Source Implementation
class UserDataSourceImpl implements  UsersDataSource {

  // final instances
  final DioData dioData;
  final FlutterSecureStorage secureStorage;
  final OptionsData optionsData;
  final AppConstants appConstants;

  // constructor
  UserDataSourceImpl({
    required this.dioData,
    required this.secureStorage,
    required this.optionsData,
    required this.appConstants,
  });

  // Get user from API
  @override
  Future<UserModel> getUser() async {
    try {
      final options = await optionsData.loadOptions();
      final userId = await secureStorage.read(key: 'userId');
      final response = await dioData.get('/users/$userId', options: options);
      if (response.statusCode != 200) {
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Ban user from API
  @override
  Future<String> banUser(String userToBanId) async {
    try {
      final options = await optionsData.loadOptions();
      final userId = await secureStorage.read(key: 'userId');
      final response = await dioData.get(
        '/users/ban/$userId/$userToBanId',
        options: options,
      );
      if (response.statusCode != 200) {
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
      return response.data['message'] ?? 'User banned successfully';
    } catch (e) {
      rethrow;
    }
  }

  // Unban user from API
  @override
  Future<String> unbanUser(String userToUnbanId) async {
    try {
      final options = await optionsData.loadOptions();
      final userId = await secureStorage.read(key: 'userId');
      final response = await dioData.get(
        '/users/unban/$userId/$userToUnbanId',
        options: options,
      );
      if(response.statusCode != 200) {
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
      return response.data['message'] ?? 'User unbanned successfully';
    } catch (e) {
      rethrow;
    }
  }

  // Get all users from API
  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final options = await optionsData.loadOptions();
      final response = await dioData.get('/users', options: options);
      if (response.statusCode != 200) {
        // throw error if response is not successful
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
      if (response.data == null) {
        // if response data is null, return empty list
        return [];
      }
      // return list of users if response is successful
      return (response.data as List<dynamic>)
          .map<UserModel>((user) => UserModel.fromJson(user))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Update username from API
  @override
  Future<String> updateUsername(String username) async {
    try {
      final options = await optionsData.loadOptions();
      final userId = await secureStorage.read(key: 'userId');
      final response = await dioData.put(
        '/users/$userId',
        data: {'username': username},
        options: options,
      );
      // throw error if response is not successful
      if(response.statusCode != 200) {
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
      // return message if response is successful
      return response.data['message'] ?? 'Username updated successfully';
    } catch (e) {
      rethrow;
    }
  }

  // Update password from API
  @override
  Future<String> updatePassword(String oldPassword, String newPassword) async {
    try {
      final options = await optionsData.loadOptions();
      final userId = await secureStorage.read(key: 'userId');
      final response = await dioData.put(
        '/users/$userId/password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
        options: options,
      );
      // throw error if response is not successful
      if (response.statusCode != 200) {
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
      // return message if response is successful
      return response.data['message'] ?? 'Password updated successfully';
    } catch (e) {
      rethrow;
    }
  }

  // Create registration code from API
  @override
  Future<String> createRegistrationCode(String code) async {
    try {
      final options = await optionsData.loadOptions();
      final response = await dioData.post(
        '/codes',
        data: {'code': code},
        options: options,
      );
      // throw error if response is not successful
      if(response.statusCode != 200) {
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
      // return message if response is successful
      return response.data['message'] ?? 'Code created successfully';
    } catch (e) {
      rethrow;
    }
  }
}
