import '../../models/server_status.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import 'http_method.dart';
import 'package:dio/dio.dart';
import '../data_source.dart';
import '../../models/models.dart';
import 'api_endpoints.dart';
import 'http_client.dart';
import '../../constants/storage_keys.dart';
import 'package:intl/intl.dart';

class HttpDataSource implements DataSource {
  final HttpClient _httpClient;

  HttpDataSource._internal({String? baseUrl})
      : _httpClient = HttpClient(
          baseUrl: baseUrl ?? 'http://192.168.2.199:3000',
        );

  factory HttpDataSource({String? baseUrl}) {
    final savedUrl = StorageService.getString(StorageKeys.serverUrl);
    return HttpDataSource._internal(
        baseUrl: baseUrl ?? savedUrl ?? 'http://192.168.2.199:3000');
  }

  void setToken(String token) {
    _httpClient.setToken(token);
    StorageService.setString(StorageKeys.token, token);
  }

  void clearToken() {
    _httpClient.clearToken();
    StorageService.remove(StorageKeys.token);
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
        data: book.toJsonCreate(),
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
        data: book.toJsonRequest(),
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
  Future<AccountItemResponse> getAccountItems(
    String bookId, {
    List<String>? categories,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? shopCodes,
  }) async {
    try {
      final formattedStartDate = startDate != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(startDate)
          : null;
      final formattedEndDate = endDate != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(endDate)
          : null;

      final response = await _httpClient.request<Map<String, dynamic>>(
        path: '${ApiEndpoints.accountItems}/list',
        method: HttpMethod.post,
        data: {
          'accountBookId': bookId,
          if (categories != null) 'categories': categories,
          if (type != null) 'type': type,
          if (formattedStartDate != null) 'startDate': formattedStartDate,
          if (formattedEndDate != null) 'endDate': formattedEndDate,
          if (shopCodes != null) 'shopCodes': shopCodes,
        },
      );
      return AccountItemResponse.fromJson(response);
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
        data: item.toJsonCreate(),
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
        data: item.toJsonUpdate(),
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
        data: shop.toJsonCreate(),
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
        data: shop.toJsonUpdate(),
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

  @override
  Future<List<UserFund>> getUserFunds() async {
    try {
      final response = await _httpClient.request<List<dynamic>>(
        path: '${ApiEndpoints.funds}/list',
        method: HttpMethod.get,
      );
      return response.map((json) => UserFund.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // 资金账户相关方法
  @override
  Future<List<AccountBookFund>> getBookFunds(String bookId) async {
    try {
      final response = await _httpClient.request<List<dynamic>>(
        path: '${ApiEndpoints.funds}/bookfunds',
        method: HttpMethod.post,
        data: {'accountBookId': bookId},
      );
      return response.map((json) => AccountBookFund.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<UserFund> createFund(UserFund fund) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: ApiEndpoints.funds,
        method: HttpMethod.post,
        data: fund.toRequestCreateJson(),
      );
      return UserFund.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<UserFund> updateFund(String id, UserFund fund) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: '${ApiEndpoints.funds}/$id',
        method: HttpMethod.patch,
        data: fund.toRequestUpdateJson(),
      );
      return UserFund.fromJson(response);
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
  @override
  Future<Map<String, dynamic>?> login({
    required String username,
    required String password,
    bool isLocalStorage = false,
  }) async {
    if (isLocalStorage) return null;

    final response = await _httpClient.request<Map<String, dynamic>>(
      path: '${ApiEndpoints.auth}/login',
      method: HttpMethod.post,
      data: {
        'username': username,
        'password': password,
      },
    );

    // 直接返回 data 部分
    return response;
  }

  @override
  Future<void> register({
    required String username,
    required String password,
    required String email,
    String? nickname,
  }) async {
    await _httpClient.request<void>(
      path: '${ApiEndpoints.users}/register',
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
      path: '${ApiEndpoints.users}/current',
      method: HttpMethod.get,
    );
    return response;
  }

  @override
  Future<Map<String, dynamic>> updateUserInfo(Map<String, dynamic> data) async {
    final response = await request<Map<String, dynamic>>(
      path: '${ApiEndpoints.users}/current',
      method: HttpMethod.patch,
      data: data,
    );
    return response;
  }

  @override
  Future<String> resetInviteCode() async {
    final response = await request<Map<String, dynamic>>(
      path: '${ApiEndpoints.users}/invite/reset',
      method: HttpMethod.put,
    );
    return response['inviteCode'];
  }

  @override
  Future<Map<String, dynamic>?> getUserByInviteCode(String inviteCode) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: '${ApiEndpoints.users}/invite/$inviteCode',
        method: HttpMethod.get,
      );
      return response;
    } catch (e) {
      return null;
    }
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
      return await _httpClient.request<T>(
        path: path,
        method: method,
        queryParameters: queryParameters,
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ServerStatus> serverStatus() async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: ApiEndpoints.health,
        method: HttpMethod.get,
      );
      return ServerStatus.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>?> validateToken(String token) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: '${ApiEndpoints.auth}/validate',
        method: HttpMethod.get,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setBaseUrl(String url) async {
    await StorageService.setString(StorageKeys.serverUrl, url);
    _httpClient.setBaseUrl(url);
  }

  @override
  Future<BatchDeleteResult> batchDeleteAccountItems(
      List<String> itemIds) async {
    try {
      final response = await _httpClient.request<Map<String, dynamic>>(
        path: '${ApiEndpoints.accountItems}/batch/delete',
        method: HttpMethod.post,
        data: itemIds,
      );
      return BatchDeleteResult.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // 继续实现其他方法...
}
