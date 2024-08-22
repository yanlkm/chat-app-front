import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SocketError {

  @JsonKey(name: 'error')
  final String? error;


  SocketError({this.error});

  factory SocketError.fromJson(Map<String, dynamic> json) {
    return SocketError(
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
    };
  }
}
