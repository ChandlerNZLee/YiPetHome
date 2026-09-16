// lib/core/network/api-exception.dart
import 'package:dio/dio.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;

  const ApiException({this.statusCode, required this.message, this.data});

  @override
  String toString() {
    return 'ApiException('
        'statusCode: $statusCode, '
        'message: $message'
        ')';
  }
}

ApiException mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return const ApiException(message: 'Connection timeout');

    case DioExceptionType.sendTimeout:
      return const ApiException(message: 'Request timeout');

    case DioExceptionType.receiveTimeout:
      return const ApiException(message: 'Server response timeout');

    case DioExceptionType.connectionError:
      return const ApiException(message: 'Unable to connect to the server');

    case DioExceptionType.cancel:
      return const ApiException(message: 'Request cancelled');

    case DioExceptionType.badCertificate:
      return const ApiException(message: 'Invalid server certificate');

    case DioExceptionType.badResponse:
      final response = error.response;

      String message = 'Request failed';

      final data = response?.data;

      if (data is Map<String, dynamic>) {
        final serverMessage = data['message'];

        if (serverMessage is String) {
          message = serverMessage;
        } else if (serverMessage is List) {
          message = serverMessage.join('\n');
        }
      }

      return ApiException(
        statusCode: response?.statusCode,
        message: message,
        data: response?.data,
      );

    case DioExceptionType.unknown:
      return ApiException(message: error.message ?? 'Network error');

    default:
      return const ApiException(message: 'Unknown error');
  }
}
