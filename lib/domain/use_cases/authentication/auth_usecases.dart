import 'package:my_app/data/repositories/authentication/auth_repository_impl.dart';
import 'package:either_dart/either.dart';
import '../../../utils/errors/handlers/network_error_handler.dart';
import '../../entities/authentication/token_entity.dart';
import '../../entities/users/user_entity.dart';

// Authentication Use Cases
class AuthUseCases {
// AuthRepositoryImpl instance
  final AuthRepositoryImpl authRepositoryImpl;

  // Constructor
  const AuthUseCases({
    required this.authRepositoryImpl,
  });

  // Login
  Future<Either<NetworkErrorHandler, TokenEntity>> login(String username, String password) async {
    return authRepositoryImpl.login(username, password);
  }

  // Logout
  Future<Either<NetworkErrorHandler, void>> logout() async {
    return authRepositoryImpl.logout();
  }

  // Register
  Future<Either<NetworkErrorHandler, UserEntity>> register(String username, String password, String code) async {
    return authRepositoryImpl.register(username, password, code);
  }
}