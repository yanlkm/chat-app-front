class MessageSocket {
  final String roomId;
  final String username;
  final String message;
  final DateTime? createdAt;

  MessageSocket( {required this.roomId, required this.username, required this.message,this.createdAt});

  factory MessageSocket.fromJson(Map<String, dynamic> json) {
    return MessageSocket(
      roomId: json['roomId'],
      username: json['username'],
      message: json['message'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'username': username,
      'message': message,
      'createdAt': createdAt,
    };
  }
}
