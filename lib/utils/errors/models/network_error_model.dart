import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

// NetworkError : network error model class
@JsonSerializable()
class NetworkError extends Equatable {
  // error
  @JsonKey(name: 'error')
  final String? error;

  // Constructor
  const NetworkError({this.error});

  // Factory method : create NetworkError from json
  factory NetworkError.fromJson(Map<String, dynamic> json) {
    return NetworkError(
      error: json['error'],
    );
  }

  // Method : convert NetworkError to json
  Map<String, dynamic> toJson() => {
    'error': error,
  };

  // Override props
  @override
  List<Object?> get props => [error];
}