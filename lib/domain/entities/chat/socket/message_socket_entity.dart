import 'package:equatable/equatable.dart';

// Message Socket Entity : MessageSocketEntity
class MessageSocketEntity extends Equatable {
  final String roomId;
  final String username;
  final String? userId;
  final String message;
  final DateTime? createdAt;
// constructor
  const MessageSocketEntity({
    required this.roomId,
    required this.username,
    this.userId,
    required this.message,
    this.createdAt,
  });

  // Equatable props
  @override
  List<Object?> get props => [roomId, username, userId, message, createdAt];
}
