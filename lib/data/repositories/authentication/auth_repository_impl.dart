import 'package:my_app/data/data_sources/authentication/auth_data_source_impl.dart';
import 'package:either_dart/either.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import '../../../domain/entities/authentication/token_entity.dart';
import '../../../domain/repositories/authentication/auth_repository.dart';
import '../../../utils/errors/handlers/network_error_handler.dart';
import '../../models/authentication/sign_in/sign_in_model.dart';
import '../../models/authentication/sign_up/sign_up_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSourceImpl authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<NetworkErrorHandler, TokenEntity>> login(String username, String password) async {
    try {
      final signInModel = SignInModel(username: username, password: password);
      final tokenModel = await authRemoteDataSource.login(signInModel);
      return Right(tokenModel.toEntity());
    } on NetworkErrorHandler catch (error) {
      return Left(error);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, void>> logout() async {
    try {
      await authRemoteDataSource.logout();
      return const Right(null);
    } on NetworkErrorHandler catch (error) {
      return Left(error);
    }
  }

  @override
  Future<Either<NetworkErrorHandler, UserEntity>> register(String username, String password, String code) async {
    try {
      final signUpModel = SignUpModel(username: username, password: password, code: code);
      final userModel = await authRemoteDataSource.register(signUpModel);
      return Right(userModel.toEntity());
    } on NetworkErrorHandler catch (error) {
      return Left(error);
    }
  }
}