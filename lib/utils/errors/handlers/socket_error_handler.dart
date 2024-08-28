import 'dart:async';

import 'package:equatable/equatable.dart';
import 'dart:io';

// SocketErrorHandler : socket error handler class
class SocketErrorHandler extends Equatable implements Exception {
  // message
  final String message;

  // Public named constructor
  const SocketErrorHandler(this.message);

  // Factory constructor : create SocketErrorHandler from exception
  factory SocketErrorHandler.fromException(dynamic exception) {
    // Check the type of exception and set the message accordingly
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

  // Override toString method
  @override
  String toString() => 'SocketError: $message';

  // Override props
  @override
  List<Object?> get props => [message];
}
