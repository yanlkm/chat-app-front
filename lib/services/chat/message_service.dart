import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/message.dart';

class MessageService {
  final String baseUrl = dotenv.env['BASE_URL']!;

  Future<List<Message>> fetchMessages(String roomId) async {
    const secureStorage = FlutterSecureStorage();
    String? token = await secureStorage.read(key: 'token');
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    try {
      final dio = Dio();
      final response = await dio.get(
        '${baseUrl!}/messages/$roomId',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token,
          },
          followRedirects: true,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        // if the server returns a 200 OK response
        // if the message data is null, return an empty list
        if (response.data == null) {
          return [];
        }
        // if the message data is not null, return a list of messages
        return (response.data as List<dynamic>)
            .map<Message>((message) => Message.fromJson(message))
            .toList();
      } else {
        throw Exception('Failed to load messages : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load messages : $e');
    }
  }
}

