// lib/models/auth/common-response.dart

class CommonResponse {
  final bool success;
  final String message;

  const CommonResponse({required this.success, required this.message});

  factory CommonResponse.fromJson(Map<String, dynamic> json) {
    return CommonResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
