import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

// User Model
@JsonSerializable()
class SignInModel extends Equatable {
  final String username;
  final String password;

  const SignInModel({required this.username, required this.password});

  // From Json
  Map<String, dynamic> toJson() => {'username': username, 'password': password};

  // Equatable props
  @override
  List<Object?> get props => [username, password];
}
