import 'dart:io';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../models/network_error_model.dart';

// NetworkErrorHandler : network error handler class
class NetworkErrorHandler extends Equatable implements Exception{

  // message
  late final String message;
  // status code
  late final int? statusCode;

  // Constructor : initialize message and status code with DioException
  NetworkErrorHandler.fromDioError(DioException dioException) {
    // set status code from response
    statusCode = dioException.response?.statusCode;

    // check the type of error and set the message accordingly
    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = 'Request to API server was cancelled';
        break;

      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout with API server';
        break;

      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout in connection with API server';
        break;

      case DioExceptionType.sendTimeout:
        message = 'Send timeout in connection with API server';
        break;

      case DioExceptionType.connectionError:
        if (dioException.error.runtimeType == SocketException) {
          message = 'Please check your internet connection';
          break;
        } else {
          message = 'Unexpected error occurred';
          break;
        }

      case DioExceptionType.badCertificate:
        message = 'Bad Certificate';
        break;

      case DioExceptionType.badResponse:
        final model = NetworkError.fromJson(dioException.response?.data as Map<String, dynamic>);
        message = model.error ?? 'Unexpected bad response';
        break;

      case DioExceptionType.unknown:
        message = 'Unexpected error occurred';
        break;
    }
  }

  // Override toString method
  @override
  List<Object?> get props => [message, statusCode];
}