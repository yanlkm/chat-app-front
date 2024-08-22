import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/presentation/pages/authentication/sign_in/sign_in_page.dart';
import 'package:my_app/presentation/pages/authentication/sign_up/sign_up_page.dart';
import 'package:my_app/presentation/pages/home/home_page.dart';
import 'package:my_app/presentation/pages/home/welcome/welcome_page.dart';
import 'package:my_app/services/authentification/login_service.dart';
import 'package:my_app/services/authentification/logout_service.dart';
import 'package:my_app/services/authentification/register_service.dart';
import 'package:my_app/services/room/room_service.dart';
import 'package:my_app/services/user/user_service.dart';
import 'package:my_app/services/user/user_rooms_service.dart';
import 'controllers/authentification/login_controller.dart';
import 'controllers/authentification/logout_controller.dart';
import 'controllers/authentification/register_controller.dart';
import 'controllers/user/user_controller.dart';
import 'controllers/room/room_controller.dart';
import 'controllers/user/user_rooms_controller.dart';

// Import the required classes for UserUseCases
import 'data/data_sources/rooms/rooms_data_source_impl.dart';
import 'data/data_sources/users/users_data_source_impl.dart';
import 'data/repostiories/rooms/room_repository_impl.dart';
import 'data/repostiories/users/user_repository_impl.dart';
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

  // Initialize dependencies for UserUseCases
  final OptionsData optionsData = OptionsData(secureStorage);
  final AppConstants appConstants = AppConstants(); // Assuming AppConstants has a default constructor
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

  // Initialize UserRepositoryImpl
  final UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl(
    userRemoteDataSource: userDataSourceImpl,
  );

  // Initialize RoomRepositoryImpl
  final RoomRepositoryImpl roomRepositoryImpl = RoomRepositoryImpl(
    roomRemoteDataSource: roomDataSourceImpl,
  );

  // Initialize UserUseCases
  final UserUseCases userUseCases = UserUseCases(
    userRepositoryImpl: userRepositoryImpl,
  );

  // Initialize RoomUseCases
  final RoomUsesCases roomUsesCases = RoomUsesCases(
    roomRepositoryImpl: roomRepositoryImpl,
  );

  // Check if a token is present in secureStorage
  String? token = await secureStorage.read(key: 'token');

  runApp(MyApp(initialRoute: token == null ? '/welcome' : '/home', userUseCases: userUseCases, roomUsesCases: roomUsesCases));
}

// Add the MyApp class
class MyApp extends StatelessWidget {
  // Add the properties
  final RegisterService registerService = RegisterService();
  final LoginService loginService = LoginService();
  final LogoutService logoutService = LogoutService();
  final UserService userService = UserService();
  final UserRoomsService userRoomsService = UserRoomsService();
  final RegisterController registerController = RegisterController(registerService: RegisterService());
  final LoginController loginController = LoginController(loginService: LoginService());
  final LogoutController logoutController = LogoutController(logoutService: LogoutService());
  final UserController userController = UserController(userService: UserService());
  final RoomController roomController = RoomController(roomService: RoomService());
  final UserRoomsController userRoomsController = UserRoomsController(userRoomsService: UserRoomsService());
  final String initialRoute;

  // Add the userUseCases as a property
  final UserUseCases userUseCases;

  // Add the roomUsesCases as a property
  final RoomUsesCases roomUsesCases;

  // Add the initialRoute and userUseCases to the constructor
  MyApp({super.key, required this.initialRoute, required this.userUseCases, required this.roomUsesCases});

  // Add the build method
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Add the title
      title: 'Chat-app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      // Add the routes
      routes: {
        '/signup': (context) => SignUpPage(registerController: registerController),
        '/signing': (context) => SignInPage(loginController: loginController),
        '/welcome': (context) => const WelcomePage(),
        '/home': (context) => HomePage(
          userController: userController,
          roomController: roomController,
          logoutController: logoutController,
          userRoomsService: userRoomsService,
          userRoomsController: userRoomsController,
          userUseCases: userUseCases,
          roomUsesCases: roomUsesCases,
        ),
      },
    );
  }
}
