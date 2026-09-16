// lib/core/network/api-client.dart
import 'package:dio/dio.dart';

import 'api-config.dart';
import 'api-exception.dart';
import 'auth-interceptor.dart';

class ApiClient {
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        contentType: Headers.jsonContentType,
        headers: const {'Accept': 'application/json'},
        validateStatus: (status) {
          return status != null && status >= 200 && status < 300;
        },
      ),
    );

    _dio.interceptors.add(AuthInterceptor());

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }

  static final ApiClient instance = ApiClient._internal();

  late final Dio _dio;

  Dio get dio => _dio;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return parser(response.data);
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return parser(response.data);
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return parser(response.data);
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return parser(response.data);
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return parser(response.data);
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}
