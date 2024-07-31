import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userID;
  final String? username;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? role;
  final String? validity;
  final List<String>? rooms;

  const UserEntity({
    this.userID,
    this.username,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.validity,
    this.rooms,
});

  @override
  List<Object?> get props {
   return
     [userID, username, createdAt, updatedAt, role, validity, rooms];
  }

}