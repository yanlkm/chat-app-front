import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';

import '../../../utils/data/entity_convertible_data.dart';

@JsonSerializable()
class RoomModel extends Equatable with EntityConvertible<RoomModel,RoomEntity> {
  // define variables with JsonKey annotation
  @JsonKey(name: '_id')
  final String roomID;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'creator')
  final String? creator;
  @JsonKey(name: 'members')
  final List<String>? members;
  @JsonKey(name: 'hashtags')
  final List<String>? hashtags;
  @JsonKey(name: 'messages')
  final List<String>? messages;

  // constructor
  const RoomModel({
    required this.roomID,
    this.creator,
    this.hashtags,
    this.messages,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.members,
  });

  // from Json
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    // Define the date format that matches JSON
    final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS ZZZ");

    return RoomModel(
      roomID: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      creator: json['creator'] ?? '',
      members:
      json['members'] != null ? List<String>.from(json['members']) : [],
      createdAt: json['createdAt'] != null
          ? dateFormat.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? dateFormat.parse(json['updatedAt'])
          : DateTime.now(),
      messages: json['messages'] != null
          ? List<String>.from(json['messages'])
          : [],
      hashtags: json['hashtags'] != null
          ? List<String>.from(json['hashtags'])
          : [],
    );
  }


  // to Json
  @override
  List<Object?> get props => [
        roomID,
        name,
        createdAt,
        updatedAt,
        description,
        members,
        hashtags,
        messages
      ];

  // to Entity
  @override
  RoomEntity toEntity() {
    return RoomEntity(
      roomID: roomID,
      name: name,
      description: description,
      creator: creator,
      members: members,
      createdAt: createdAt,
      updatedAt: updatedAt,
      messages: messages,
      hashtags: hashtags,
    );
  }
}
