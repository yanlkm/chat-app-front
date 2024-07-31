import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class NetworkError extends Equatable {
  @JsonKey(name: 'error')
  final String? error;

  const NetworkError({this.error});

  factory NetworkError.fromJson(Map<String, dynamic> json) {
    return NetworkError(
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() => {
    'error': error,
  };

  @override
  List<Object?> get props => [error];
}