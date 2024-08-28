import 'package:equatable/equatable.dart';

// Token Entity
class TokenEntity extends Equatable {
  // final attribute
  final String token;

  // constructor
  const TokenEntity({required this.token});

  // Equatable props
  @override
  List<Object?> get props => [token];
}
