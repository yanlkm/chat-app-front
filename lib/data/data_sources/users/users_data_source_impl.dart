
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/data/data_sources/users/users_data_source.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/options_data.dart';
import '../../../utils/data/dio_data.dart';
import '../../models/users/user_model.dart';

class UserDataSourceImpl implements UsersDataSource {
  final DioData dioData;
  final FlutterSecureStorage secureStorage;
  final OptionsData optionsData;
  final AppConstants appConstants;

  UserDataSourceImpl({
    required this.dioData,
    required this.secureStorage,
    required this.optionsData,
    required this.appConstants,
  });

  @override
  Future<UserModel> getUser() async {
    try {
      final options = await optionsData.loadOptions();
      final userId = await secureStorage.read(key: 'userId');
      final response = await dioData.get('/users/$userId', options: options);
      if (response.statusCode != 200) {
        throw response.data['error'] ?? 'Failed to get user';
      }
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

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
        throw response.data['error'] ?? 'Failed to ban user';
      }
      return response.data['message'] ?? 'User banned successfully';
    } catch (e) {
      rethrow;
    }
  }

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
        throw response.data['error'] ?? 'Failed to unban user';
      }
      return response.data['message'] ?? 'User unbanned successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final options = await optionsData.loadOptions();
      final response = await dioData.get('/users', options: options);
      if (response.statusCode != 200) {
        throw response.data['error'] ?? 'Failed to get users';
      }
      return (response.data as List<dynamic>)
          .map<UserModel>((user) => UserModel.fromJson(user))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

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
      if(response.statusCode != 200) {
        throw response.data['error'] ?? 'Failed to update username';
      }
      return response.data['message'] ?? 'Username updated successfully';
    } catch (e) {
      rethrow;
    }
  }

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
      if (response.statusCode != 200) {
        throw response.data['error'] ?? 'Failed to update password';
      }
      return response.data['message'] ?? 'Password updated successfully';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> createRegistrationCode(String code) async {
    try {
      final options = await optionsData.loadOptions();
      final response = await dioData.post(
        '/codes',
        data: {'code': code},
        options: options,
      );
      if(response.statusCode != 200) {
        throw response.data['error'] ?? 'Failed to create code';
      }
      return response.data['message'] ?? 'Code created successfully';
    } catch (e) {
      rethrow;
    }
  }
}
