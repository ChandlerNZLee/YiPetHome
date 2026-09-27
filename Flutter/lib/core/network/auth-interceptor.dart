// lib/core/network/auth-interceptor.dart
import 'package:dio/dio.dart';
import '../auth/token-storage.dart';

import '../auth/auth-session.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenStorage.instance.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept'] = 'application/json';

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;

    final path = err.requestOptions.path;

    final isPublicAuthRequest =
        path.contains('/auth/app/login') || path.contains('/auth/app/register');

    if (statusCode == 401 && !isPublicAuthRequest) {
      await AuthSession.instance.expire();
    }

    handler.next(err);
  }
}
