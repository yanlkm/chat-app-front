import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';

import '../../../utils/data/entity_convertible_data.dart';

@JsonSerializable()
class RoomModel extends Equatable with EntityConvertible<RoomModel,RoomEntity> {
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

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomID: json['_id']?? '',
      name: json['name']?? '',
      description: json['description']?? '',
      creator: json['creator']?? '',
      members:
          json['members'] != null ? List<String>.from(json['members']) : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      messages: json['messages'] != null
          ? List<String>.from(json['messages'])
          : [],
      hashtags: json['hashtags'] != null
          ? List<String>.from(json['hashtags'])
          : [],
    );
  }

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
