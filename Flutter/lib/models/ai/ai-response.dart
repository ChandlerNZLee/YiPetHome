// lib/models/appointment/appointment-response.dart

class AIResponse {
  final String message;

  const AIResponse({required this.message});

  factory AIResponse.fromJson(Map<String, dynamic> json) {
    return AIResponse(message: json['message'] as String);
  }
}
