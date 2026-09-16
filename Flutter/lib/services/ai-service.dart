// lib/services/ai-service.dart
import 'dart:io';

import 'package:dio/dio.dart';

import '../core/network/api-client.dart';
import '../models/ai/ai-response.dart';

class AIService {
  AIService._();

  static final AIService instance = AIService._();

  final ApiClient _api = ApiClient.instance;

  Future<AIResponse> sendMessage(String message) async {
    final result = await _api.post<AIResponse>(
      '/ai/chat',
      data: {'message': message},
      parser: (data) {
        return AIResponse.fromJson(data as Map<String, dynamic>);
      },
    );

    return result;
  }

  Future<AIResponse> sendVisionMessage(String message, File image) async {
    final fileName = image.path.split('/').last;

    final formData = FormData.fromMap({
      'message': message,
      'image': await MultipartFile.fromFile(image.path, filename: fileName),
    });

    final result = await _api.post<AIResponse>(
      '/ai/vision',
      data: formData,
      options: Options(
        contentType: Headers.multipartFormDataContentType,
        sendTimeout: const Duration(minutes: 2),
        receiveTimeout: const Duration(minutes: 2),
      ),
      parser: (data) {
        return AIResponse.fromJson(data as Map<String, dynamic>);
      },
    );

    return result;
  }
}
