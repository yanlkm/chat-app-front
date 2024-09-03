import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/chat/db/message_db_entity.dart';

import '../../../../utils/data/entity_convertible_data.dart';

// Message DB Model : MessageDBModel
@JsonSerializable()
class MessageDBModel extends Equatable with EntityConvertible<MessageDBModel,MessageDBEntity>{

  // define variables with JsonKey annotation
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

  // constructor
  const MessageDBModel
      ({this.messageID,
        this.username,
        this.userId,
        this.content,
        this.createdAt,
        this.roomID
      });

  // from Json
  factory MessageDBModel.fromJson( Map<String, dynamic> json) {
    // Define the date format that matches JSON
    final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS ZZZ");

    return MessageDBModel(
      messageID: json['_id'] ?? '',
      content: json['content'] ?? '',
      roomID: json['roomId'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      createdAt: json['createdAt'] != null ? dateFormat.parse(json['createdAt']) : DateTime.now(),
    );
  }
// to Json
  @override
  List<Object?> get props => [messageID,content, roomID, userId, username, createdAt];

  // to Entity
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