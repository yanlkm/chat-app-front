import 'package:either_dart/either.dart';
import 'package:my_app/domain/entities/authentication/token_entity.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import 'package:my_app/utils/errors/handlers/network_error_handler.dart';


abstract class AuthRepository {
  Future<Either<NetworkErrorHandler, TokenEntity>> login(String username, String password);
  Future<Either<NetworkErrorHandler, void>> logout();
  Future<Either<NetworkErrorHandler, UserEntity>> register(String username, String password, String code);
}