import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/presentation/pages/authentication/sign_in/sign_in_page.dart';
import 'package:my_app/presentation/pages/authentication/sign_up/sign_up_page.dart';
import 'package:my_app/presentation/pages/home/home_page.dart';
import 'package:my_app/presentation/pages/home/welcome/welcome_page.dart';
// Import the required classes for UserUseCases
import 'data/data_sources/authentication/auth_data_source_impl.dart';
import 'data/data_sources/chat/db/message_db_data_source_impl.dart';
import 'data/data_sources/chat/socket/message_socket_data_source_impl.dart';
import 'data/data_sources/rooms/rooms_data_source_impl.dart';
import 'data/data_sources/users/users_data_source_impl.dart';
import 'data/repositories/authentication/auth_repository_impl.dart';
import 'data/repositories/chat/db/message_db_repository_impl.dart';
import 'data/repositories/chat/socket/message_socket_repository_impl.dart';
import 'data/repositories/rooms/room_repository_impl.dart';
import 'data/repositories/users/user_repository_impl.dart';
import 'domain/use_cases/authentication/auth_usecases.dart';
import 'domain/use_cases/chat/db/message_db_usecases.dart';
import 'domain/use_cases/chat/socket/message_socket_usescases.dart';
import 'domain/use_cases/rooms/room_usecases.dart';
import 'domain/use_cases/users/user_usecases.dart';
import 'utils/constants/app_constants.dart';
import 'utils/constants/options_data.dart';
import 'utils/data/dio_data.dart';

Future<void> main() async {
  // Load env file
  await dotenv.load(fileName: ".env");

  // Initialize FlutterSecureStorage
  const secureStorage = FlutterSecureStorage();

  // Initialize dependencies for UseCases
  final OptionsData optionsData = OptionsData(secureStorage);
  final AppConstants appConstants =
      AppConstants(); // Assuming AppConstants has a default constructor
  final DioData dioData = DioData();

  // Initialize UserDataSourceImpl
  final UserDataSourceImpl userDataSourceImpl = UserDataSourceImpl(
    secureStorage: secureStorage,
    optionsData: optionsData,
    appConstants: appConstants,
    dioData: dioData,
  );

  // Initialize RoomDataSourceImpl
  final RoomsDataSourceImpl roomDataSourceImpl = RoomsDataSourceImpl(
    secureStorage: secureStorage,
    optionsData: optionsData,
    appConstants: appConstants,
    dioData: dioData,
  );

  // Initialize AuthDataSourceImpl
  final AuthDataSourceImpl authDataSourceImpl = AuthDataSourceImpl(
    secureStorage: secureStorage,
    optionsData: optionsData,
    appConstants: appConstants,
    dioData: dioData,
  );

  // Initialize MessageDBDataSourceImpl
  final MessageDBDataSourceImpl messageDBDataSourceImpl =
      MessageDBDataSourceImpl(
    secureStorage: secureStorage,
    optionsData: optionsData,
    appConstants: appConstants,
    dioData: dioData,
  );

  // Initialize MessageSocketDataSourceImpl
  final MessageSocketDataSourceImpl messageSocketDataSourceImpl =
      MessageSocketDataSourceImpl();

  // Initialize UserRepositoryImpl
  final UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl(
    userRemoteDataSource: userDataSourceImpl,
  );

  // Initialize RoomRepositoryImpl
  final RoomRepositoryImpl roomRepositoryImpl = RoomRepositoryImpl(
    roomRemoteDataSource: roomDataSourceImpl,
  );

// Initialize AuthRepositoryImpl
  final AuthRepositoryImpl authRepositoryImpl = AuthRepositoryImpl(
    authRemoteDataSource: authDataSourceImpl,
  );

// Initialize MessageDBRepositoryImpl
  final MessageDBRepositoryImpl messageDBRepositoryImpl =
      MessageDBRepositoryImpl(messageDBDataSourceImpl);

// Initialize MessageSocketRepositoryImpl
  final MessageSocketRepositoryImpl messageSocketRepositoryImpl =
      MessageSocketRepositoryImpl(messageSocketDataSourceImpl);

  // Initialize UserUseCases
  final UserUseCases userUseCases = UserUseCases(
    userRepositoryImpl: userRepositoryImpl,
  );

  // Initialize RoomUseCases
  final RoomUsesCases roomUsesCases = RoomUsesCases(
    roomRepositoryImpl: roomRepositoryImpl,
  );

  // Initialize AuthUseCases
  final AuthUseCases authUseCases = AuthUseCases(
    authRepositoryImpl: authRepositoryImpl,
  );

  // Initialize MessageDBUseCases
  final MessageDBUseCases messageDBUseCases = MessageDBUseCases(
    messageDBRepositoryImpl: messageDBRepositoryImpl,
  );

  // Initialize MessageSocketUseCases
  final MessageSocketUseCases messageSocketUseCases = MessageSocketUseCases(
    messageSocketRepositoryImpl: messageSocketRepositoryImpl,
  );

  // Check if a token is present in secureStorage
  String? token = await secureStorage.read(key: 'token');

  runApp(MyApp(
      initialRoute: token == null ? '/welcome' : '/home',
      userUseCases: userUseCases,
      roomUsesCases: roomUsesCases,
      authUseCases: authUseCases,
      messageDBUseCases: messageDBUseCases,
      messageSocketUseCases: messageSocketUseCases));
}

// Add the MyApp class
class MyApp extends StatelessWidget {


  final String initialRoute;

  // Add the userUseCases as a property
  final UserUseCases userUseCases;

  // Add the roomUsesCases as a property
  final RoomUsesCases roomUsesCases;

  // Add the authUseCases as a property
  final AuthUseCases authUseCases;

  // Add the messageDBUseCases as a property
  final MessageDBUseCases messageDBUseCases;

  // Add the messageSocketUseCases as a property
  final MessageSocketUseCases messageSocketUseCases;

  // Add the initialRoute and userUseCases to the constructor
  const MyApp(
      {super.key,
      required this.initialRoute,
      required this.userUseCases,
      required this.roomUsesCases,
      required this.authUseCases,
      required this.messageDBUseCases,
      required this.messageSocketUseCases});

  // Add the build method
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      // Add the title
      title: 'Chat-app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      // Add the routes
      routes: {
        '/signup': (context) =>
            SignUpPage(authUseCases: authUseCases), // Add the SignUpPage route
        '/signing': (context) => SignInPage(
              authUseCases: authUseCases,
            ), // Add the SignInPage route
        '/welcome': (context) => const WelcomePage(),
        '/home': (context) => HomePage(
              userUseCases: userUseCases,
              roomUsesCases: roomUsesCases,
              authUseCases: authUseCases,
              messageDBUseCases: messageDBUseCases,
              messageSocketUseCases: messageSocketUseCases,
            ),
      },
    );
  }
}
