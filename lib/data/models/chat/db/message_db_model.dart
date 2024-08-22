import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/chat/db/message_db_entity.dart';

import '../../../../utils/data/entity_convertible_data.dart';

@JsonSerializable()
class MessageDBModel extends Equatable with EntityConvertible<MessageDBModel,MessageDBEntity>{

  @JsonKey(name: '_id')
  final String? messageID;
  @JsonKey(name: 'roomId')
  final String? roomID;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'userId')
  final String? userId;
  @JsonKey(name: 'content')
  final String? content;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  const MessageDBModel
      ({this.messageID,
        this.username,
        this.userId,
        this.content,
        this.createdAt,
        this.roomID
      });

  factory MessageDBModel.fromJson( Map<String, dynamic> json) {

    return MessageDBModel(
      messageID: json['_id'] ?? '',
      content: json['content'] ?? '',
      roomID: json['roomId'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [messageID,content, roomID, userId, username, createdAt];

  @override
  MessageDBEntity toEntity() {
    return
    MessageDBEntity(
      username: username,
      userId: userId,
      roomID: roomID,
      createdAt: createdAt,
      content: content,
      messageID: messageID
    );
  }




}