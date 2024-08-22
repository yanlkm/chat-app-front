import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/authentication/token_entity.dart';
import '../../../utils/data/entity_convertible_data.dart';


@JsonSerializable()
class TokenModel extends Equatable with EntityConvertible<TokenModel, TokenEntity> {
  final String token;

  TokenModel({required this.token});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(token: json['token']);
  }

  Map<String, dynamic> toJson() => {'token': token};

  @override
  List<Object?> get props => [token];

  @override
  TokenEntity toEntity() => TokenEntity(token: token);
}
