// This class is used to store the token that is received from the server
class Token {
  String token="";
  // Constructor
  Token({required this.token});

  // Convert JSON to Token
  Token.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  // Convert Token to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    return data;
  }
}