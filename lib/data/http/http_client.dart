import 'package:dio/dio.dart';
import 'api_exception.dart';
import 'http_method.dart';

class HttpClient {
  final Dio _dio;
  String? _token;

  HttpClient({required String baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
          },
        )) {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      logPrint: (object) {
        print('HTTP Log: $object');
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, handler) async {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          print('Request timeout, retrying...');
          try {
            final response = await _dio.request(
              e.requestOptions.path,
              data: e.requestOptions.data,
              queryParameters: e.requestOptions.queryParameters,
              options: Options(
                method: e.requestOptions.method,
                headers: e.requestOptions.headers,
              ),
            );
            return handler.resolve(response);
          } catch (e) {
            return handler.next(e as DioException);
          }
        }
        return handler.next(e);
      },
    ));
  }

  void setToken(String token) {
    _token = token;
    print('Setting token in HttpClient: $token');

    _dio.options.headers = {
      ..._dio.options.headers,
      'Authorization': 'Bearer $token',
    };
    print('Updated Dio headers: ${_dio.options.headers}');
  }

  void clearToken() {
    _token = null;
    _dio.options.headers.remove('Authorization');
  }

  Future<T> request<T>({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      print('Request path: $path');
      print('Request data: $data');
      final response = await _dio.request<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: Options(
          method: method.value,
          headers: {
            'Content-Type': 'application/json',
            if (_token != null) 'Authorization': 'Bearer $_token',
          },
        ),
      );

      // 处理统一响应格式
      final apiResponse = response.data!;
      final code = apiResponse['code'] as int;
      final message = apiResponse['message'] as String;

      // 处理错误状态码
      if (code >= 400) {
        throw ApiException(
          statusCode: code,
          message: message,
        );
      }

      // 处理成功响应
      final responseData = apiResponse['data'];

      // 类型检查
      if (T.toString().startsWith('List<') && responseData is! List) {
        throw ApiException(
          message: 'Expected List but got ${responseData.runtimeType}',
        );
      } else if (T.toString() == 'Map<String, dynamic>' &&
          responseData is! Map) {
        throw ApiException(
          message: 'Expected Map but got ${responseData.runtimeType}',
        );
      }

      return responseData as T;
    } on DioException catch (e) {
      print('DioException: $e');
      print('DioException response: ${e.response?.data}');
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException e) {
    if (e.response?.data != null && e.response?.data is Map) {
      final apiResponse = e.response!.data as Map<String, dynamic>;
      return ApiException(
        statusCode: apiResponse['code'] as int,
        message: apiResponse['message'] as String,
      );
    }
    return ApiException(
      statusCode: e.response?.statusCode,
      message: e.message ?? 'Request failed',
    );
  }

  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }
}
