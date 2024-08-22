import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';


@JsonSerializable()
class SignInModel extends Equatable {
  final String username;
  final String password;

  const SignInModel({required this.username, required this.password});


  Map<String, dynamic> toJson() => {'username': username, 'password': password};

  @override
  List<Object?> get props => [username, password];
}
