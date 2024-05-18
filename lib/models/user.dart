class User {
  final String? userID;
   String? username;
   final DateTime? createdAt;
   DateTime? updatedAt;
   List<String>? rooms = [];

  User({
    this.userID,
    this.username,
    this.createdAt,
    this.updatedAt,
    this.rooms,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      rooms: json['joinedSalons'] != null ? List<String>.from(json['joinedSalons']) : [],
      userID: json['_id'],
    );
  }


}
