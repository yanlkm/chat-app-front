import 'package:either_dart/either.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';


abstract class UserRepository {

Future<Either<NetworkErrorHandler,UserEntity>> getUser();

Future<Either<NetworkErrorHandler,String>> updateUsername(String username);

Future<Either<NetworkErrorHandler,String>> updatePassword(String oldPassword, String newPassword);

Future<Either<NetworkErrorHandler,String>> banUser(String userToBanId);

Future<Either<NetworkErrorHandler,String>> unbanUser(String userToUnbanId);

Future<Either<NetworkErrorHandler,List<UserEntity>>> getUsers();

}