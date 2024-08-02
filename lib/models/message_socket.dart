// This file contains the model for the message socket
class MessageSocket {
  // Properties
  final String roomId;
  final String username;
  final String? userId;
  final String message;
  final DateTime? createdAt;

  // Constructor
  MessageSocket({ required this.userId,required this.roomId, required this.username, required this.message,this.createdAt});

  // Convert JSON to MessageSocket
  factory MessageSocket.fromJson(Map<String, dynamic> json) {
    return MessageSocket(
      roomId: json['roomId'],
      username: json['username'],
      userId: json['userId'],
      message: json['message'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  // Convert MessageSocket to JSON
  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'username': username,
      'userId': userId,
      'message': message,
      'createdAt': createdAt,
    };
  }
}
