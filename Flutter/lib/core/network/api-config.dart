// lib/core/network/api-config.dart
class ApiConfig {
  ApiConfig._();

  // static const String baseUrl = 'http://localhost:3001/';
  static const String baseUrl = 'https://api.nzdc.co.uk/';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);
}
