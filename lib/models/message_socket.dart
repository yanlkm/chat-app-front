class MessageSocket {
  final String roomId;
  final String username;
  final String? userId;
  final String message;
  final DateTime? createdAt;

  MessageSocket({ required this.userId,required this.roomId, required this.username, required this.message,this.createdAt});

  factory MessageSocket.fromJson(Map<String, dynamic> json) {
    return MessageSocket(
      roomId: json['roomId'],
      username: json['username'],
      userId: json['userId'],
      message: json['message'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

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
