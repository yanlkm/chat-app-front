import 'package:either_dart/either.dart';
import 'package:my_app/data/repositories/users/user_repository_impl.dart';

import '../../../utils/errors/handlers/network_error_handler.dart';
import '../../entities/users/user_entity.dart';

class UserUseCases {
  final UserRepositoryImpl userRepositoryImpl;

  const UserUseCases({
    required this.userRepositoryImpl,
  });

  Future<Either<NetworkErrorHandler, UserEntity>> getUser() async {
    return userRepositoryImpl.getUser();
  }

  Future<Either<NetworkErrorHandler, List<UserEntity>>> getUsers() async {
    return userRepositoryImpl.getUsers();
  }

  Future<Either<NetworkErrorHandler, String>> banUser(String userToBanId) async {
    return userRepositoryImpl.banUser(userToBanId);
  }

  Future<Either<NetworkErrorHandler, String>> updateUsername(String username) async {
    return userRepositoryImpl.updateUsername(username);
  }

  Future<Either<NetworkErrorHandler, String>> updatePassword(String oldPassword, String newPassword) async {
    return userRepositoryImpl.updatePassword(oldPassword, newPassword);
  }

  Future<Either<NetworkErrorHandler, String>> unbanUser(String userToUnbanId) async {
    return userRepositoryImpl.unbanUser(userToUnbanId);
  }

  Future<Either<NetworkErrorHandler,String>> createRegistrationCode(String userId) async {
    return userRepositoryImpl.createRegistrationCode(userId);
  }
}