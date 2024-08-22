import 'package:equatable/equatable.dart';

class MessageSocketEntity extends Equatable {
  final String roomId;
  final String username;
  final String? userId;
  final String message;
  final DateTime? createdAt;

  const MessageSocketEntity({
    required this.roomId,
    required this.username,
    this.userId,
    required this.message,
    this.createdAt,
  });

  @override
  List<Object?> get props => [roomId, username, userId, message, createdAt];
}
