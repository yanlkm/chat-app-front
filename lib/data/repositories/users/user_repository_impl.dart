import 'package:either_dart/either.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';
import '../../../domain/repositories/users/user_repository.dart';
import '../../data_sources/users/users_data_source_impl.dart';
import '../../models/users/user_model.dart';

// User Repository Implementation
class UserRepositoryImpl implements UserRepository {
  final UserDataSourceImpl userRemoteDataSource;
  // Constructor
  UserRepositoryImpl({
    required this.userRemoteDataSource,
  });

  // Get User implementation : Future<Either<NetworkErrorHandler, UserEntity>>
  @override
  Future<Either<NetworkErrorHandler, UserEntity>> getUser() async {
    try {
      // Get user
      final UserModel user = await userRemoteDataSource.getUser();
      // Return user entity
      return Right<NetworkErrorHandler, UserEntity>(user.toEntity());
    } on NetworkErrorHandler catch (e) {
      // Catch error if any error occurs
      return Left<NetworkErrorHandler, UserEntity>(e);
    }
  }

  // Ban User implementation : Future<Either<NetworkErrorHandler, String>>
  @override
  Future<Either<NetworkErrorHandler, String>> banUser(String userToBanId) async {
    try {
      // Ban user
      final String response = await userRemoteDataSource.banUser(userToBanId);
      // Return response if successful
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      // Catch error if any error occurs
      return Left<NetworkErrorHandler, String>(e);
    }
  }

  // Get Users implementation : Future<Either<NetworkErrorHandler, List<UserEntity>>
  @override
  Future<Either<NetworkErrorHandler, List<UserEntity>>> getUsers() async {
    try {
      // Get users
      final List<UserModel> users = await userRemoteDataSource.getUsers();
      // Map users to entities
      final List<UserEntity> userEntities = users.map((user) => user.toEntity()).toList();
      return Right<NetworkErrorHandler, List<UserEntity>>(userEntities);
    } on NetworkErrorHandler catch (e) {
      // Catch error if any error occurs
      return Left<NetworkErrorHandler, List<UserEntity>>(e);
    }
  }

  // Update Password implementation : Future<Either<NetworkErrorHandler, String>>
  @override
  Future<Either<NetworkErrorHandler, String>> updatePassword(String oldPassword, String newPassword) async {
    try {
      // Update password
      final String response = await userRemoteDataSource.updatePassword(oldPassword, newPassword);
      // Return response if successful
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      // Catch error if any error occurs
      return Left<NetworkErrorHandler, String>(e);
    }
  }

  // Update Username implementation : Future<Either<NetworkErrorHandler, String>>
  @override
  Future<Either<NetworkErrorHandler, String>> updateUsername(String username) async {
    try {
      // Update username
      final String response = await userRemoteDataSource.updateUsername(username);
      // return response if successful
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      // catch error if any error occurs
      return Left<NetworkErrorHandler, String>(e);
    }
  }

  // Unban User implementation : Future<Either<NetworkErrorHandler, String>>
  @override
  Future<Either<NetworkErrorHandler, String>> unbanUser(String userToUnbanId) async {
    try {
      // return success
      final String response = await userRemoteDataSource.unbanUser(userToUnbanId);
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      // catch if any error occurs
      return Left<NetworkErrorHandler, String>(e);
    }
  }


// Create a code registration : Future<Either<NetworkErrorHandler, String>>
  @override
  Future<Either<NetworkErrorHandler, String>> createRegistrationCode(String code) async {
    try {
      // return success response
      final String response = await userRemoteDataSource.createRegistrationCode(code);
      return Right<NetworkErrorHandler, String>(response);
    } on NetworkErrorHandler catch (e) {
      // catch error if any error occurs
      return Left<NetworkErrorHandler, String>(e);

  }
}
}
