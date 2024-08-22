import 'package:my_app/data/repostiories/authentication/auth_repository_impl.dart';
import 'package:either_dart/either.dart';
import '../../../utils/errors/handlers/network_error_handler.dart';
import '../../entities/authentication/token_entity.dart';
import '../../entities/users/user_entity.dart';

class AuthUseCases {

  final AuthRepositoryImpl authRepositoryImpl;

  const AuthUseCases({
    required this.authRepositoryImpl,
  });

  Future<Either<NetworkErrorHandler, TokenEntity>> login(String username, String password) async {
    return authRepositoryImpl.login(username, password);
  }

  Future<Either<NetworkErrorHandler, void>> logout(String token) async {
    return authRepositoryImpl.logout(token);
  }

  Future<Either<NetworkErrorHandler, UserEntity>> register(String username, String password, String code) async {
    return authRepositoryImpl.register(username, password, code);
  }
}