// This file contains the model for the message object
class Message {
  // Properties
   final String? messageID;
   String? content;
   String? roomID;
   String? username;
   String? userId;
   DateTime? createdAt;

  // Constructor
  Message({
     required this.messageID,
     this.content,
     this.roomID,
     this.username,
     this.userId,
     this.createdAt,
  });

  // Convert JSON to Message
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageID: json['_id'] ?? '',
      content: json['content'] ?? '',
      roomID: json['room'] ?? '',
      username: json['username'] ?? '',
      userId: json['userId'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  // Convert Message to JSON
  Map<String, dynamic> toJson() {
    return {
      'messageID': messageID,
      'content': content,
      'roomID': roomID,
      'username': username,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}