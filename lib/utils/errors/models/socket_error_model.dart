import 'package:json_annotation/json_annotation.dart';

// SocketError : socket error model class
@JsonSerializable()
class SocketError {

  // error
  @JsonKey(name: 'error')
  final String? error;


  // Constructor
  SocketError({this.error});

  // Factory method : create SocketError from json
  factory SocketError.fromJson(Map<String, dynamic> json) {
    return SocketError(
      error: json['error'] as String?,
    );
  }

  // Method : convert SocketError to json
  Map<String, dynamic> toJson() {
    return {
      'error': error,
    };
  }
}
