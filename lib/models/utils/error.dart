// ErrorResponse model
class ErrorResponse {
  // Error message
  final String error;

  // Constructor
  ErrorResponse({required this.error});

  // Convert JSON to ErrorResponse
  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      error: json['error'],
    );
  }
}
