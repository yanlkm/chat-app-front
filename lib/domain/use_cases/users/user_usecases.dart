import 'package:either_dart/either.dart';
import 'package:my_app/data/repositories/users/user_repository_impl.dart';

import '../../../utils/errors/handlers/network_error_handler.dart';
import '../../entities/users/user_entity.dart';

//
class UserUseCases {
  // UserRepositoryImpl instance
  final UserRepositoryImpl userRepositoryImpl;

  // Constructor
  const UserUseCases({
    required this.userRepositoryImpl,
  });

  // Get User
  Future<Either<NetworkErrorHandler, UserEntity>> getUser() async {
    return userRepositoryImpl.getUser();
  }

  // Get Users
  Future<Either<NetworkErrorHandler, List<UserEntity>>> getUsers() async {
    return userRepositoryImpl.getUsers();
  }

  // Ban User
  Future<Either<NetworkErrorHandler, String>> banUser(String userToBanId) async {
    return userRepositoryImpl.banUser(userToBanId);
  }

  // Update Username
  Future<Either<NetworkErrorHandler, String>> updateUsername(String username) async {
    return userRepositoryImpl.updateUsername(username);
  }

  // Update Password
  Future<Either<NetworkErrorHandler, String>> updatePassword(String oldPassword, String newPassword) async {
    return userRepositoryImpl.updatePassword(oldPassword, newPassword);
  }

  // Unban User
  Future<Either<NetworkErrorHandler, String>> unbanUser(String userToUnbanId) async {
    return userRepositoryImpl.unbanUser(userToUnbanId);
  }

  // Create Registration Code
  Future<Either<NetworkErrorHandler,String>> createRegistrationCode(String userId) async {
    return userRepositoryImpl.createRegistrationCode(userId);
  }
}