import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import '../constants/app_constants.dart';

// DioData : dio data class
class DioData {
  // Dio instance
  late final Dio _dio;
  // AppConstants instance
  late final AppConstants _appConstants;

  // Constructor : initialize Dio and AppConstants
  DioData() {
    _appConstants = AppConstants();
    _dio = Dio();
    _dio
      ..options.baseUrl = _appConstants.baseUrl!
      ..options.headers = {
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        HttpHeaders.authorizationHeader: '${_appConstants.token}',
      }
      // enabler redirection
      ..options.followRedirects = true
      // validate status
      ..options.validateStatus = (status) {
        return status! < 500;
      }
      // connect timeout of 15 seconds
      ..options.connectTimeout = const Duration(milliseconds: 15000)
      ..options.receiveTimeout = const Duration(milliseconds: 15000)
      ..options.responseType = ResponseType.json
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Do something before request is sent
            return handler.next(options); //continue
          },
          onResponse: (response, handler) {
            // Do something with response data
            return handler.next(response); // continue
          },
          onError: (DioException e, handler) {
            // Do something with response error
            return handler.next(e); //continue
          },
        ),
      );
    // custom HttpClient that ignores self-signed certificate issues
    _dio.httpClientAdapter = IOHttpClientAdapter()
      ..createHttpClient = () {
        final client = HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) {
            return true;
          };
        return client;
      };
  }
  /// * GET
  Future<Response<dynamic>> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }
  /// * POST
  Future<Response<dynamic>> post(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }
  /// * PUT
  Future<Response<dynamic>> put(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }
  /// * PATCH
  Future<Response<dynamic>> patch(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }
  /// * DELETE
  Future<dynamic> delete(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }
}