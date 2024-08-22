import 'dart:async';

import 'package:equatable/equatable.dart';
import 'dart:io';

class SocketErrorHandler extends Equatable implements Exception {
  final String message;

  // Public named constructor
  const SocketErrorHandler(this.message);

  factory SocketErrorHandler.fromException(dynamic exception) {
    if (exception is SocketException) {
      return const SocketErrorHandler(
        'No internet connection. Please check your network settings.',
      );
    } else if (exception is FormatException) {
      return const SocketErrorHandler('Invalid data format received.');
    } else if (exception is WebSocketException) {
      return SocketErrorHandler(
        'WebSocket error occurred: ${exception.message}',
      );
    } else if (exception is HandshakeException) {
      return const SocketErrorHandler('WebSocket handshake failed.');
    } else if (exception is TimeoutException) {
      return const SocketErrorHandler('Connection timed out.');
    } else if (exception is Exception) {
      return SocketErrorHandler(
        'An unexpected error occurred: ${exception.toString()}',
      );
    } else {
      return const SocketErrorHandler('Unknown error occurred.');
    }
  }

  @override
  String toString() => 'SocketError: $message';

  @override
  List<Object?> get props => [message];
}
