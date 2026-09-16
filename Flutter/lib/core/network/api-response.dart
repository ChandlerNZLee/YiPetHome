// lib/core/network/api-response.dart
class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;

  const ApiResponse({required this.code, required this.message, this.data});

  bool get success => code == 0;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      code: json['code'] ?? -1,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
    );
  }
}
