class User {
  final String? userID;
   String? username;
   final DateTime? createdAt;
   DateTime? updatedAt;
   String? validity;
   String? role;
   List<String>? rooms = [];

  User({
    this.userID,
    this.username,
    this.createdAt,
    this.updatedAt,
    this.validity,
    this.role,
    this.rooms,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      validity: json['validity'],
      role: json['role'],
      rooms: json['joinedSalons'] != null ? List<String>.from(json['joinedSalons']) : [],
      userID: json['_id'],
    );
  }


}
