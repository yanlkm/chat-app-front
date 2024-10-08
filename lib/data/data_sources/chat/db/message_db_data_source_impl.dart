import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/data/data_sources/chat/db/message_db_data_source.dart';
import 'package:my_app/data/models/chat/db/message_db_model.dart';

import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/options_data.dart';
import '../../../../utils/data/dio_data.dart';
import '../../../../utils/errors/handlers/network_error_handler.dart';

// MessageDBDataSourceImpl is a class that implements the MessageDBDataSource
class MessageDBDataSourceImpl implements MessageDBDataSource {

  // final variables for the class
  final DioData dioData;
  final FlutterSecureStorage secureStorage;
  final OptionsData optionsData;
  final AppConstants appConstants;

  // constructor
  const MessageDBDataSourceImpl({
    required this.dioData,
    required this.secureStorage,
    required this.appConstants,
    required this.optionsData
  });

  // fetchMessages method to get all messages from a Room
  @override
  Future<List<MessageDBModel>> fetchMessages(String roomId) async {
    final options = await optionsData.loadOptions();

    try {
      final response = await dioData.get(
          '/messages/$roomId',
          options: options
      );
      if (response.statusCode == 200) {
        if (response.data == null) {
          return [];
        }
        // if the message data is not null, return a list of messages
        return (response.data as List<dynamic>)
            .map<MessageDBModel>((message) => MessageDBModel.fromJson(message))
            .toList();
      } else {
        // Throw NetworkErrorHandler if the response status code is not 200
        throw NetworkErrorHandler.fromDioError(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );      }
    }catch(e) {
      rethrow;
    }
  }

}