import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/data/data_sources/users/users_data_source.dart';

import '../../../models/user.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/options_data.dart';
import '../../../utils/data/dio_data.dart';
import '../../models/users/user_model.dart';

class UserDataSourceImpl implements  UsersDataSource {
  final DioData dioData;
  final FlutterSecureStorage secureStorage;
  final OptionsData optionsData;
  final AppConstants appConstants;

  UserDataSourceImpl(this.secureStorage, this.optionsData, this.appConstants,
      {
    required this.dioData
  });

  @override
  Future<UserModel> getUser() async {
    try {
      final response = await dioData.get('/user');
      final userModel = UserModel.fromJson(response.data);
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> banUser(String userToBanId) async {
 Options options = await optionsData.loadOptions();
 var userId = appConstants.userId;
    try {
      final response = await dioData.get(
        '/users/ban/$userId/$userToBanId',
        options: options,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> getUsers() {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<String> unbanUser(String userToUnbanId) {
    // TODO: implement unbanUser
    throw UnimplementedError();
  }

  @override
  Future<String> updatePassword(String oldPassword, String newPassword) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<String> updateUsername(String username) {
    // TODO: implement updateUsername
    throw UnimplementedError();
  }

}