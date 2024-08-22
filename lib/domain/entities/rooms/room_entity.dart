
import 'package:equatable/equatable.dart';

class RoomEntity extends Equatable {

  final String roomID;
  final String? name;
  final String? description;
  final String? creator;
  final List<String>? members;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? messages;
  final List<String>? hashtags;

  const RoomEntity({
    required this.roomID,
    this.name,
    this.description,
    this.creator,
    this.members,
    this.createdAt,
    this.updatedAt,
    this.messages,
    this.hashtags,
  });

  RoomEntity copyWith({
    String? roomID,
    String? name,
    String? description,
    String? creator,
    List<String>? members,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? messages,
    List<String>? hashtags,
  }) {
    return RoomEntity(
      roomID: roomID ?? this.roomID,
      name: name ?? this.name,
      description: description ?? this.description,
      creator: creator ?? this.creator,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
      hashtags: hashtags ?? this.hashtags,
    );
  }

  @override
  List<Object?> get props => [roomID, name, description, creator, members, createdAt, updatedAt, messages, hashtags];

}