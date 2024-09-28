// create model class for MessageLocalModel that will uses ObjectBox
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

import '../../../../domain/entities/chat/db/message_db_entity.dart';
// MessageLocalModel class
@Entity()
class MessageLocalModel {
  // id field
  @Id(assignable: true)
  int id = 0;

  // roomId field
  String roomID;

  // content field
  String content;

  // createdAt field
  String createdAt;

  // username field
  String username;

  // userId field
  String userId;

  // messageID field
  String messageID;

  // constructor
  MessageLocalModel({
    required this.roomID,
    required this.content,
    required this.createdAt,
    required this.username,
    required this.userId,
    required this.messageID,
  });

  // to entity
  MessageDBEntity toEntity() {
    final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
    return MessageDBEntity(
      roomID: roomID,
      content: content,
      createdAt: dateFormat.parse(createdAt),
      username: username,
      userId: userId,
      messageID: messageID,
    );
  }


}