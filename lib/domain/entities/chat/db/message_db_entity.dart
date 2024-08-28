import 'package:equatable/equatable.dart';

// Message DB Entity  : MessageDBEntity
class MessageDBEntity extends Equatable {
  // Properties
  final String? messageID;
  final String? content;
  final String? roomID;
  final  String? username;
  final String? userId;
  final DateTime? createdAt;

  // Constructor
  const MessageDBEntity({
    this.messageID,
    this.content,
    this.roomID,
    this.username,
    this.userId,
    this.createdAt,
  });

  // Method to return entity with changed attributes
  MessageDBEntity copyWith(
      {String? messageID,
      String? content,
      String? roomID,
      String? username,
      String? userId,
      DateTime? createdAt}) {
    return MessageDBEntity(
        messageID: messageID ?? this.messageID,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        roomID: roomID ?? this.roomID,
        userId: userId ?? this.userId,
        username: username ?? this.username);
  }

  // Equatable props
  @override
  List<Object?> get props => [messageID, content, createdAt, roomID, username, userId];


}
