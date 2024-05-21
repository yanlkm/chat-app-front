import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/services/authentification/login_service.dart';
import 'package:my_app/services/authentification/logout_service.dart';
import 'package:my_app/services/authentification/register_service.dart';
import 'package:my_app/services/room/room_service.dart';
import 'package:my_app/services/user/profile_service.dart';
import 'package:my_app/services/user/user_rooms_service.dart';
import 'package:my_app/views/authentification/login_page.dart';
import 'package:my_app/views/authentification/register_page.dart';
import 'package:my_app/views/home/welcome_page.dart';
import 'package:my_app/views/home/home_page.dart';
import 'controllers/authentification/login_controller.dart';
import 'controllers/authentification/logout_controller.dart';
import 'controllers/authentification/register_controller.dart';
import 'controllers/user/profile_controller.dart';
import 'controllers/room/room_controller.dart';
import 'controllers/user/user_rooms_controller.dart';
Future main() async {
  // Load env file
  await dotenv.load(fileName: ".env");

  // Initialize FlutterSecureStorage
  const secureStorage = FlutterSecureStorage();

  // Check if a token is present in secureStorage
  String? token = await secureStorage.read(key: 'token');

  runApp(MyApp(initialRoute: token == null ? '/welcome' : '/home'));
}

class MyApp extends StatelessWidget {
  final RegisterService registerService = RegisterService();
  final LoginService loginService = LoginService();
  final LogoutService logoutService = LogoutService();
  final ProfileService profileService = ProfileService();
  final UserRoomsService userRoomsService = UserRoomsService();
  final RegisterController registerController = RegisterController(registerService: RegisterService());
  final LoginController loginController = LoginController(loginService: LoginService());
  final LogoutController logoutController = LogoutController(logoutService: LogoutService());
  final ProfileController profileController = ProfileController(profileService: ProfileService());
  final RoomController roomController = RoomController(roomService: RoomService());
  final UserRoomsController userRoomsController = UserRoomsController(userRoomsService: UserRoomsService());
  final String initialRoute;

  MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      routes: {
        '/signup': (context) => RegisterPage(registerController: registerController),
        '/signing': (context) => LoginPage(loginController: loginController),
        '/welcome': (context) => const WelcomePage(),
        '/home': (context) => HomePage(
          profileController: profileController,
          roomController: roomController,
          logoutController: logoutController,
          userRoomsService: userRoomsService,
          userRoomsController: userRoomsController,
        ),
      },
    );
  }
}
