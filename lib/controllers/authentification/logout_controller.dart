import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/services/authentification/login_service.dart';
import 'package:my_app/services/authentification/logout_service.dart';

class LogoutController {
  LogoutService logoutService;

  LogoutController({required this.logoutService});

  Future<void> Logout() async {
    const secureStorage = FlutterSecureStorage();
    String? token = await secureStorage.read(key: 'token');

    if (token != null) {
      await logoutService.Logout();
    }

    // Clear secure storage
    await secureStorage.delete(key: 'token');
    await secureStorage.delete(key: 'userId');
  }
}