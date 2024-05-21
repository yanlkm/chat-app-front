class Message {
   final String? messageID;
   String? content;
   String? roomID;
   String? username;
   DateTime? createdAt;

  Message({
     required this.messageID,
     this.content,
     this.roomID,
     this.username,
     this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageID: json['_id'] ?? '',
      content: json['content'] ?? '',
      roomID: json['room'] ?? '',
      username: json['username'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageID': messageID,
      'content': content,
      'roomID': roomID,
      'username': username,
      'createdAt': createdAt,
    };
  }
}