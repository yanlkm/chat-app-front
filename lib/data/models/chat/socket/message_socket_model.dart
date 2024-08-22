import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../domain/entities/chat/socket/message_socket_entity.dart';
import '../../../../utils/data/entity_convertible_data.dart';


@JsonSerializable()
class MessageSocketModel extends Equatable with EntityConvertible<MessageSocketModel, MessageSocketEntity> {
  final String roomId;
  final String username;
  final String? userId;
  final String message;
  final DateTime? createdAt;

  const MessageSocketModel({
    required this.roomId,
    required this.username,
    this.userId,
    required this.message,
    this.createdAt,
  });

  factory MessageSocketModel.fromJson(Map<String, dynamic> json) {
    return MessageSocketModel(
      roomId: json['roomId'],
      username: json['username'],
      userId: json['userId'],
      message: json['message'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'username': username,
      'userId': userId,
      'message': message,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [roomId, username, userId, message, createdAt];

  @override
  MessageSocketEntity toEntity() {
    return MessageSocketEntity(
      roomId: roomId,
      username: username,
      userId: userId,
      message: message,
      createdAt: createdAt,
    );
  }
}
