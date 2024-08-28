import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/authentication/token_entity.dart';
import '../../../utils/data/entity_convertible_data.dart';

// Token Model
@JsonSerializable()
class TokenModel extends Equatable with EntityConvertible<TokenModel, TokenEntity> {
  // final instances
  final String token;

  // constructor
  TokenModel({required this.token});

  // from Json
  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(token: json['token']);
  }

  // to Json
  Map<String, dynamic> toJson() => {'token': token};

  // Equatable props
  @override
  List<Object?> get props => [token];

  // to Entity
  @override
  TokenEntity toEntity() => TokenEntity(token: token);
}
