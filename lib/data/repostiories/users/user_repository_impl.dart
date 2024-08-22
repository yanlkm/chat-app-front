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
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, String>(e);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, List<UserEntity>>> getUsers() async {
    try {
      final List<UserModel> users = await userRemoteDataSource.getUsers();
      final List<UserEntity> userEntities = users.map((user) => user.toEntity()).toList();
      return Right<NetworkErrorHandler, List<UserEntity>>(userEntities);
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, List<UserEntity>>(e);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, String>> updatePassword(String oldPassword, String newPassword) async {
    try {
      final String response = await userRemoteDataSource.updatePassword(oldPassword, newPassword);
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, String>(e);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, String>> updateUsername(String username) async {
    try {
      final String response = await userRemoteDataSource.updateUsername(username);
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, String>(e);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, String>> unbanUser(String userToUnbanId) async {
    try {
      final String response = await userRemoteDataSource.unbanUser(userToUnbanId);
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, String>(e);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, String>> createRegistrationCode(String code) async {

    try {
      final String response = await userRemoteDataSource.createRegistrationCode(code);
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      return Left<NetworkErrorHandler, String>(e);

  }
}
}
