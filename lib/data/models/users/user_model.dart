import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import 'package:my_app/utils/data/entity_convertible_data.dart';

@JsonSerializable()
class UserModel extends Equatable with EntityConvertible<UserModel,UserEntity> {

  @JsonKey(name : '_id')
  final String? userID;
  @JsonKey(name :'username')
  final String? username;
  @JsonKey(name :'createdAt')
  final DateTime? createdAt;
  @JsonKey(name :'updatedAt')
  final DateTime? updatedAt;
  @JsonKey(name :'role')
  final String? role;
  @JsonKey(name :'validity')
  final String? validity;
  @JsonKey(name :'joinedSalons')
  final List<String>? rooms;

  UserModel({
    this.userID,
    this.username,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.validity,
    this.rooms,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      validity: json['validity'],
      role: json['role'],
      rooms: json['joinedSalons'] != null ? List<String>.from(json['joinedSalons']) : [],
      userID: json['_id'],
    );
  }


  @override
  List<Object?> get props => [userID, username, createdAt, updatedAt, role, validity, rooms];

  @override
  UserEntity toEntity() {
    return UserEntity(
      userID : userID,
      username: username,
      createdAt : createdAt,
      updatedAt : updatedAt,
      role : role,
      validity : validity,
      rooms : rooms,

    );
  }



}
