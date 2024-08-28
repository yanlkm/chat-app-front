import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

// Sign Up Model
@JsonSerializable()
class SignUpModel extends Equatable {
  final String username;
  final String password;
  final String code;
  final String validity = 'valid';
  final String role = 'user';

  const SignUpModel(
      {required this.username, required this.password, required this.code});

  // From Json
  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'code': code,
        'validity': validity,
        'role': role
      };
// Equatable props
  @override
  List<Object?> get props => [username, password, code];
}
