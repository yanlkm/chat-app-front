import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OptionsData {
  final FlutterSecureStorage secureStorage;

  OptionsData(this.secureStorage);

  Future<Options> loadOptions() async {
    // get token from secure storage
    String? token = await secureStorage.read(key: 'token');

    return Options(
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
      followRedirects: true, // enabler redirection
      validateStatus: (status) {
        return status! < 500;
      },
    );
  }

}