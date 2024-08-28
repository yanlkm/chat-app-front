import 'package:equatable/equatable.dart';

// User Entity
class UserEntity extends Equatable {
  final String? userID;
  final String? username;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? role;
  final String? validity;
  final List<String>? rooms;

  // Constructor
  const UserEntity({
    this.userID,
    this.username,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.validity,
    this.rooms,
  });

  // Method to return entity with changed attributes
  UserEntity copyWith({
    String? userID,
    String? username,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? role,
    String? validity,
    List<String>? rooms,
  }) {
    return UserEntity(
      userID: userID ?? this.userID,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      role: role ?? this.role,
      validity: validity ?? this.validity,
      rooms: rooms ?? this.rooms,
    );
  }

  // define setter for user entity
  UserEntity setUpdatedAt(DateTime newDate) {
    return UserEntity(
      userID: userID,
      username: username,
      createdAt: createdAt,
      updatedAt: newDate,
      role: role,
      validity: validity,
      rooms: rooms,
    );
  }
// Equatable props
  @override
  List<Object?> get props => [userID, username, createdAt, updatedAt, role, validity, rooms];
}
