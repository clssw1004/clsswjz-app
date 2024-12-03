import 'http_method.dart';
import 'package:dio/dio.dart';
import '../data_source.dart';
import '../../models/models.dart';
import 'api_endpoints.dart';
import 'http_client.dart';

class HttpDataSource implements DataSource {
  final HttpClient _httpClient;
  String? _token;

  HttpDataSource({String baseUrl = 'http://192.168.2.147:3000'})
      : _httpClient = HttpClient(baseUrl: baseUrl);

  void setToken(String token) {
    _token = token;
    print('Setting token in HttpDataSource: $token');
    _httpClient.setToken(token);
  }

  void clearToken() {
    _token = null;
    print('Clearing token in HttpDataSource');
    _httpClient.clearToken();
  }

  // 账本相关方法
  @override
  Future<List<AccountBook>> getAccountBooks() async {
    try {
      final response = await _httpClient.request<List<dynamic>>(
        path: ApiEndpoints.accountBooks,
        method: HttpMethod.get,
      );
      return response.map((json) => AccountBook.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AccountBook> createAccountBook(AccountBook book) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: ApiEndpoints.accountBooks,
        method: HttpMethod.post,
        data: book.toJson(),
      );
      return AccountBook.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AccountBook> updateAccountBook(String id, AccountBook book) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: '${ApiEndpoints.accountBooks}/$id',
        method: HttpMethod.patch,
        data: book.toJson(),
      );
      return AccountBook.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteAccountBook(String id) async {
    try {
      await _httpClient.request<void>(
        path: '${ApiEndpoints.accountBooks}/$id',
        method: HttpMethod.delete,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // 账目相关方法
  @override
  Future<List<AccountItem>> getAccountItems(
    String bookId, {
    List<String>? categories,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await _httpClient.request<List<dynamic>>(
        path: ApiEndpoints.accountItems,
        method: HttpMethod.get,
        queryParameters: {
          'accountBookId': bookId,
          if (categories != null) 'categories': categories,
          if (type != null) 'type': type,
          if (startDate != null) 'startDate': startDate.toIso8601String(),
          if (endDate != null) 'endDate': endDate.toIso8601String(),
        },
      );
      return response.map((json) => AccountItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AccountItem> createAccountItem(AccountItem item) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: ApiEndpoints.accountItems,
        method: HttpMethod.post,
        data: item.toJson(),
      );
      return AccountItem.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AccountItem> updateAccountItem(String id, AccountItem item) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: '${ApiEndpoints.accountItems}/$id',
        method: HttpMethod.patch,
        data: item.toJson(),
      );
      return AccountItem.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteAccountItem(String id) async {
    try {
      await _httpClient.request<void>(
        path: '${ApiEndpoints.accountItems}/$id',
        method: HttpMethod.delete,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // 分类相关方法
  @override
  Future<List<Category>> getCategories(String bookId) async {
    try {
      final response = await _httpClient.request<List<dynamic>>(
        path: ApiEndpoints.categories,
        method: HttpMethod.get,
        queryParameters: {'accountBookId': bookId},
      );
      return response.map((json) => Category.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Category> createCategory(Category category) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: ApiEndpoints.categories,
        method: HttpMethod.post,
        data: category.toJson(),
      );
      return Category.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Category> updateCategory(String id, Category category) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: '${ApiEndpoints.categories}/$id',
        method: HttpMethod.patch,
        data: category.toJson(),
      );
      return Category.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _httpClient.request<void>(
        path: '${ApiEndpoints.categories}/$id',
        method: HttpMethod.delete,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // 商家相关方法
  @override
  Future<List<Shop>> getShops(String bookId) async {
    try {
      final response = await _httpClient.request<List<dynamic>>(
        path: ApiEndpoints.shops,
        method: HttpMethod.get,
        queryParameters: {'accountBookId': bookId},
      );
      return response.map((json) => Shop.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Shop> createShop(Shop shop) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: ApiEndpoints.shops,
        method: HttpMethod.post,
        data: shop.toJson(),
      );
      return Shop.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Shop> updateShop(String id, Shop shop) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: '${ApiEndpoints.shops}/$id',
        method: HttpMethod.patch,
        data: shop.toJson(),
      );
      return Shop.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteShop(String id) async {
    try {
      await _httpClient.request<void>(
        path: '${ApiEndpoints.shops}/$id',
        method: HttpMethod.delete,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // 资金账户相关方法
  @override
  Future<List<Fund>> getFunds(String bookId) async {
    try {
      final response = await _httpClient.request<List<dynamic>>(
        path: ApiEndpoints.funds,
        method: HttpMethod.get,
        queryParameters: {'accountBookId': bookId},
      );
      return response.map((json) => Fund.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Fund> createFund(Fund fund) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: ApiEndpoints.funds,
        method: HttpMethod.post,
        data: fund.toJson(),
      );
      return Fund.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Fund> updateFund(String id, Fund fund) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: '${ApiEndpoints.funds}/$id',
        method: HttpMethod.patch,
        data: fund.toJson(),
      );
      return Fund.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteFund(String id) async {
    try {
      await _httpClient.request<void>(
        path: '${ApiEndpoints.funds}/$id',
        method: HttpMethod.delete,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // 用户相关方法
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: '${ApiEndpoints.auth}/login',
        method: HttpMethod.post,
        data: {
          'username': username,
          'password': password,
        },
      );
      print('Login response in HttpDataSource: $response');
      return response;
    } catch (e) {
      print('Login error in HttpDataSource: $e');
      rethrow;
    }
  }

  Future<void> register({
    required String username,
    required String password,
    required String email,
    String? nickname,
  }) async {
    await _httpClient.request<void>(
      path: '${ApiEndpoints.auth}/register',
      method: HttpMethod.post,
      data: {
        'username': username,
        'password': password,
        'email': email,
        if (nickname != null) 'nickname': nickname,
      },
    );
  }

  @override
  Future<Map<String, dynamic>> getUserInfo() async {
    final response = await request<Map<String, dynamic>>(
      path: '${ApiEndpoints.users}/me',
      method: HttpMethod.get,
    );
    return response;
  }

  @override
  Future<Map<String, dynamic>> updateUserInfo(Map<String, dynamic> data) async {
    final response = await request<Map<String, dynamic>>(
      path: '${ApiEndpoints.users}/me',
      method: HttpMethod.patch,
      data: data,
    );
    return response;
  }

  @override
  Future<String> resetInviteCode() async {
    final response = await request<Map<String, dynamic>>(
      path: '${ApiEndpoints.users}/invite-code',
      method: HttpMethod.post,
    );
    return response['inviteCode'];
  }

  // 错误处理
  Exception _handleDioError(DioException e) {
    if (e.response?.data != null && e.response?.data is Map) {
      return Exception(e.response?.data['message'] ?? e.message);
    }
    return Exception(e.message);
  }

  @override
  Future<T> request<T>({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      if (_token != null) {
        print('Using token in request: $_token');
      } else {
        print('No token available for request');
      }

      return await _httpClient.request<T>(
        path: path,
        method: method,
        queryParameters: queryParameters,
        data: data,
      );
    } catch (e) {
      print('Request error in HttpDataSource: $e');
      rethrow;
    }
  }
  // 继续实现其他方法...
}
