class Message {
  final String messageID;
  final String content;
  final String roomID;
  final String username;
  final DateTime createdAt;

  Message({
    required this.messageID,
    required this.content,
    required this.roomID,
    required this.username,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageID: json['_id'],
      content: json['content'],
      roomID: json['room'],
      username: json['username'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'room': roomID,
      'username': username,
    };
  }
}