import 'http/http_client.dart';
import 'http/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'http/retry_policy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final HttpClient _client = HttpClient(
    baseUrl: 'http://192.168.2.147:3000',
    retryPolicy: RetryPolicy(maxAttempts: 3),
  );

  // 认证相关
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await _client.request<Map<String, dynamic>>(
      path: '${ApiEndpoints.auth}/login',
      method: HttpMethod.post,
      data: {
        'username': username,
        'password': password,
      },
    );

    final token = response['access_token'];
    _client.setToken(token);
    return {
      'token': token,
      'userInfo': {
        'userId': response['userId'],
        'username': response['username'],
        'nickname': response['nickname'],
      },
    };
  }

  static Future<void> register({
    required String username,
    required String password,
    required String email,
    String? nickname,
  }) async {
    await _client.request(
      path: '${ApiEndpoints.users}/register',
      method: HttpMethod.post,
      data: {
        'username': username,
        'password': password,
        'email': email,
        'nickname': nickname ?? username,
      },
    );
  }

  // 用户相关
  static Future<Map<String, dynamic>> getUserInfo() async {
    final response = await _client.request<Map<String, dynamic>>(
      path: '${ApiEndpoints.users}/current',
      method: HttpMethod.get,
    );
    return response;
  }

  static Future<void> updateUserInfo({
    String? nickname,
    String? email,
    String? phone,
  }) async {
    await _client.request(
      path: '${ApiEndpoints.users}/current',
      method: HttpMethod.put,
      data: {
        if (nickname != null) 'nickname': nickname,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
      },
    );
  }

  static Future<String> resetInviteCode() async {
    final response = await _client.request<Map<String, dynamic>>(
      path: '${ApiEndpoints.users}/invite/reset',
      method: HttpMethod.put,
    );
    return response['inviteCode'];
  }

  // 账本相关
  static Future<List<Map<String, dynamic>>> fetchAccountBooks() async {
    final response = await _client.request<List<dynamic>>(
      path: ApiEndpoints.accountBooks,
      method: HttpMethod.get,
    );
    return response.map((book) => Map<String, dynamic>.from(book)).toList();
  }

  static Future<void> createAccountBook({
    required String name,
    required String description,
    required String currencySymbol,
    required String icon,
  }) async {
    await _client.request(
      path: ApiEndpoints.accountBooks,
      method: HttpMethod.post,
      data: {
        'name': name,
        'description': description,
        'currencySymbol': currencySymbol,
        'icon': icon,
      },
    );
  }

  static Future<Map<String, dynamic>> updateAccountBook(
    BuildContext context,
    String bookId,
    Map<String, dynamic> data,
  ) async {
    final response = await _client.request<Map<String, dynamic>>(
      path: '${ApiEndpoints.accountBooks}/$bookId',
      method: HttpMethod.patch,
      data: {
        'id': bookId,
        'name': data['name'],
        'description': data['description'],
        'currencySymbol': data['currencySymbol'],
        'icon': data['icon'],
        'members': data['members']
            ?.map((member) => {
                  'userId': member['userId'],
                  'canViewBook': member['canViewBook'] ?? false,
                  'canEditBook': member['canEditBook'] ?? false,
                  'canDeleteBook': member['canDeleteBook'] ?? false,
                  'canViewItem': member['canViewItem'] ?? false,
                  'canEditItem': member['canEditItem'] ?? false,
                  'canDeleteItem': member['canDeleteItem'] ?? false,
                })
            .toList(),
      },
    );
    return {'code': 0, 'data': response, 'message': '更新成功'};
  }

  // 账目相关
  static Future<List<Map<String, dynamic>>> fetchAccountItems({
    required String accountBookId,
    List<String>? categories,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response = await _client.request<List<dynamic>>(
      path: '${ApiEndpoints.accountItems}/list',
      method: HttpMethod.post,
      data: {
        'accountBookId': accountBookId,
        if (categories?.isNotEmpty ?? false) 'categories': categories,
        if (type != null) 'type': type,
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
      },
    );
    return response.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  static Future<void> saveAccountItem(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final String path = data['id'] != null
        ? '${ApiEndpoints.accountItems}/${data['id']}'
        : ApiEndpoints.accountItems;

    await _client.request(
      path: path,
      method: data['id'] != null ? HttpMethod.patch : HttpMethod.post,
      data: data,
    );
  }

  // 分类相关
  static Future<List<Map<String, dynamic>>> fetchCategories(
    BuildContext context,
    String accountBookId,
  ) async {
    final response = await _client.request<List<dynamic>>(
      path: ApiEndpoints.categories,
      method: HttpMethod.get,
      queryParameters: {'accountBookId': accountBookId},
    );
    return response.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  static Future<Map<String, dynamic>> createCategory(
    BuildContext context,
    String name,
    String accountBookId,
  ) async {
    final response = await _client.request<Map<String, dynamic>>(
      path: ApiEndpoints.categories,
      method: HttpMethod.post,
      data: {
        'name': name,
        'accountBookId': accountBookId,
      },
    );
    return response;
  }

  static Future<Map<String, dynamic>> updateCategory(
    BuildContext context,
    String id,
    String name,
  ) async {
    final response = await _client.request<Map<String, dynamic>>(
      path: '${ApiEndpoints.categories}/$id',
      method: HttpMethod.patch,
      data: {'name': name},
    );
    return response;
  }

  // 商家相关
  static Future<List<Map<String, dynamic>>> fetchShops(
    BuildContext context,
    String accountBookId,
  ) async {
    final response = await _client.request<List<dynamic>>(
      path: ApiEndpoints.shops,
      method: HttpMethod.get,
      queryParameters: {'accountBookId': accountBookId},
    );
    return response.map((shop) => Map<String, dynamic>.from(shop)).toList();
  }

  static Future<Map<String, dynamic>> createShop(
    BuildContext context,
    String name,
    String accountBookId,
  ) async {
    final response = await _client.request<Map<String, dynamic>>(
      path: ApiEndpoints.shops,
      method: HttpMethod.post,
      data: {
        'name': name,
        'accountBookId': accountBookId,
      },
    );
    return response;
  }

  static Future<Map<String, dynamic>> updateShop(
    BuildContext context,
    String id,
    String name,
  ) async {
    final response = await _client.request<Map<String, dynamic>>(
      path: '${ApiEndpoints.shops}/$id',
      method: HttpMethod.patch,
      data: {'name': name},
    );
    return response;
  }

  // 资金账户相关
  static Future<List<Map<String, dynamic>>> fetchFundList(
    String accountBookId,
  ) async {
    final response = await _client.request<List<dynamic>>(
      path: '${ApiEndpoints.funds}/listByAccountBookId',
      method: HttpMethod.post,
      data: {'accountBookId': accountBookId},
    );
    return response.map((fund) => Map<String, dynamic>.from(fund)).toList();
  }

  // 用户��请相关
  static Future<Map<String, dynamic>> getUserByInviteCode(
    BuildContext context,
    String code,
  ) async {
    final response = await _client.request<Map<String, dynamic>>(
      path: '${ApiEndpoints.users}/invite/$code',
      method: HttpMethod.get,
    );
    return response;
  }

  // 系统配置相关
  static Future<String> getApiHost() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_host') ?? _client.baseUrl;
  }

  static Future<void> setApiHost(String host) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_host', host);
    _client.baseUrl = host;
  }

  // 工具方法
  static void clearToken() {
    _client.clearToken();
  }

  static void setToken(String token) {
    _client.setToken(token);
  }

  // 用户相关
  static Future<Map<String, dynamic>> getLoginUserInfo() async {
    return getUserInfo(); // 复用现有方法
  }

  static Future<Map<String, dynamic>> saveUserInfo({
    String? nickname,
    String? email,
    String? phone,
  }) async {
    await updateUserInfo(
      nickname: nickname,
      email: email,
      phone: phone,
    );
    return getUserInfo();
  }
}
