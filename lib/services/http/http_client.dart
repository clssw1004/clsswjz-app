import 'package:dio/dio.dart';
import 'api_exception.dart';
import 'retry_policy.dart';

enum HttpMethod { get, post, put, patch, delete }

class HttpClient {
  final Dio _dio;
  final RetryPolicy _retryPolicy;

  HttpClient({
    String baseUrl = '',
    RetryPolicy? retryPolicy,
  })  : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          validateStatus: (status) => status! >= 200 && status < 300,
        )),
        _retryPolicy = retryPolicy ?? RetryPolicy();

  String get baseUrl => _dio.options.baseUrl;
  set baseUrl(String value) => _dio.options.baseUrl = value;

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<T> request<T>({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? data,
    Map<String, String>? queryParameters,
  }) async {
    return _retryPolicy.retry(() async {
      try {
        Response response;

        switch (method) {
          case HttpMethod.get:
            response = await _dio.get(path, queryParameters: queryParameters);
            break;
          case HttpMethod.post:
            response = await _dio.post(path, data: data);
            break;
          case HttpMethod.put:
            response = await _dio.put(path, data: data);
            break;
          case HttpMethod.patch:
            response = await _dio.patch(path, data: data);
            break;
          case HttpMethod.delete:
            response = await _dio.delete(path);
            break;
        }

        return response.data as T;
      } on DioException catch (e) {
        throw ApiException(
          statusCode: e.response?.statusCode,
          message: e.message ?? 'Request failed',
          body: e.response?.data?.toString(),
        );
      }
    });
  }
}
