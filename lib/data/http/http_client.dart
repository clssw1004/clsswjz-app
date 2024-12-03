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
        ));

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
      print('Current _token value: $_token');
      final headers = {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };
      print('Request headers in HttpClient: $headers');
      print('Request path: $path');
      print('Request data: $data');

      final response = await _dio.request<dynamic>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: Options(
          method: method.value,
          headers: headers,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print('Response data: ${response.data}');
      print('Response type: ${response.data.runtimeType}');

      if (response.statusCode != null && response.statusCode! >= 400) {
        final responseData = response.data;
        final message = responseData is Map
            ? responseData['message']?.toString() ?? 'Request failed'
            : 'Request failed';

        throw ApiException(
          statusCode: response.statusCode,
          message: message,
          body: responseData?.toString(),
        );
      }

      final responseType = T.toString();
      if (responseType.startsWith('List<') && response.data is! List) {
        throw ApiException(
          message: 'Expected List but got ${response.data.runtimeType}',
        );
      } else if (responseType == 'Map<String, dynamic>' &&
          response.data is! Map) {
        throw ApiException(
          message: 'Expected Map but got ${response.data.runtimeType}',
        );
      }

      return response.data as T;
    } on DioException catch (e) {
      print('DioException: $e');
      print('DioException response: ${e.response?.data}');
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException e) {
    final responseData = e.response?.data;
    final message = responseData is Map
        ? responseData['message']?.toString() ?? e.message ?? 'Request failed'
        : e.message ?? 'Request failed';

    return ApiException(
      statusCode: e.response?.statusCode,
      message: message,
      body: responseData?.toString(),
    );
  }
}
