class MessageSocket {
  final String roomId;
  final String username;
  final String message;

  MessageSocket({required this.roomId, required this.username, required this.message});

  factory MessageSocket.fromJson(Map<String, dynamic> json) {
    return MessageSocket(
      roomId: json['roomId'],
      username: json['username'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'username': username,
      'message': message,
    };
  }
}
