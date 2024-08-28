import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// AppConstants : app constants class
class AppConstants {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  // get token and userid from secure storage
  late final token = secureStorage.read(key: 'token');
  late final userId = secureStorage.read(key: 'userId');
  // load .env file
  final String? baseUrl = dotenv.env['BASE_URL'];
  final String? socketUrl = dotenv.env['SOCKET_URL'];
}