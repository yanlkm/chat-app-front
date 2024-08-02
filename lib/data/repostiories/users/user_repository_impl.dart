

import 'package:either_dart/either.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';

import 'package:my_app/utils/errors/handlers/network_error_handler.dart';

import '../../../domain/repositories/users/user_repository.dart';
import '../../data_sources/users/users_data_source_impl.dart';
import '../../models/users/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSourceImpl userRemoteDataSource;

  UserRepositoryImpl({
    required this.userRemoteDataSource,
  });

  @override
  Future<Either<NetworkErrorHandler, UserEntity>> getUser() async {
    try {
      final UserModel user = await userRemoteDataSource.getUser();
      return Right<NetworkErrorHandler, UserEntity>(user.toEntity());
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, UserEntity>(e);
    }
  }


  @override
  Future<Either<NetworkErrorHandler, String>> banUser(String userToBanId) async {
    try {
      final String response = await userRemoteDataSource.banUser(userToBanId);
      return Right(response);
    } on NetworkErrorHandler catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, List<UserEntity>>> getUsers() async {
    try {
      final List<UserModel> users = await userRemoteDataSource.getUsers();
      return Right(users.map((user) => user.toEntity()).toList());
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, List<UserEntity>>(e);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, String>> updatePassword(String oldPassword, String newPassword) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<NetworkErrorHandler, String>> updateUsername(String username) {
    // TODO: implement updateUsername
    throw UnimplementedError();
  }

  @override
  Future<Either<NetworkErrorHandler, String>> unbanUser(String userToUnbanId) {
    // TODO: implement unbanUser
    throw UnimplementedError();
  }


}