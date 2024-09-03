import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../domain/entities/chat/socket/message_socket_entity.dart';
import '../../../../utils/data/entity_convertible_data.dart';

// Message Socket Model
@JsonSerializable()
class MessageSocketModel extends Equatable with EntityConvertible<MessageSocketModel, MessageSocketEntity> {
  final String roomId;
  final String username;
  final String? userId;
  final String message;
  final DateTime? createdAt;
  final String? token;

  // constructor
  const MessageSocketModel({
    required this.roomId,
    required this.username,
    this.userId,
    required this.message,
    this.createdAt,
    this.token,
  });

  // from Json
  factory MessageSocketModel.fromJson(Map<String, dynamic> json) {
    // return MessageSocketModel
    return MessageSocketModel(
      roomId: json['roomId'],
      username: json['username'],
      userId: json['userId'],
      message: json['message'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      token : json['token'],
    );
  }

  // to Json
  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'username': username,
      'userId': userId,
      'message': message,
      'createdAt': createdAt,
      'token' : token,
    };
  }

// Equatable props
  @override
  List<Object?> get props => [roomId, username, userId, message, createdAt, token];

  // to Entity
  @override
  MessageSocketEntity toEntity() {
    return MessageSocketEntity(
      roomId: roomId,
      username: username,
      userId: userId,
      message: message,
      createdAt: createdAt,
      token : token,
    );
  }
}
