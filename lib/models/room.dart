// This file contains the model for the Room object
class Room extends Object{
  String roomID;
  String? name;
  String? description;
  String? creator;
  List<String>? members;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? messages;
  List<String>? hashtags;

  // Constructor
  Room({
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

  // Convert Room to JSON
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomID: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      creator: json['creator'] ?? '',
      members: json['members'] != null ? List<String>.from(json['members']) : [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      messages: json['messages'] != null ? List<String>.from(json['messages']) : [],
      hashtags: json['hashtags'] != null ? List<String>.from(json['hashtags']) : [],
    );
  }
}
