import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../utils/api_error_handler.dart';
import '../utils/api_exception.dart';

class ApiService {
  static String _baseUrl = 'http://192.168.2.147:3000';
  static String? _token;
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    validateStatus: (status) => status! >= 200 && status < 300,
  ));

  static void setToken(String token) {
    _token = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static Map<String, String> _getHeaders({bool needsContentType = false}) {
    if (_token == null) {
      throw Exception('Token not set');
    }

    final headers = {
      'Authorization': 'Bearer $_token',
    };

    if (needsContentType) {
      headers['Content-Type'] = 'application/json';
    }

    return headers;
  }

  static bool _isSuccessStatusCode(int statusCode) {
    return statusCode == 200 || statusCode == 201;
  }

  static Future<List<Map<String, dynamic>>> fetchCategories(
    BuildContext context,
    String accountBookId,
  ) async {
    return ApiErrorHandler.wrapRequest(context, () async {
      final uri = Uri.parse('$_baseUrl/api/account/category').replace(
        queryParameters: {'accountBookId': accountBookId},
      );

      final response = await http.get(
        uri,
        headers: _getHeaders(),
      );

      if (_isSuccessStatusCode(response.statusCode)) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((category) => Map<String, dynamic>.from(category))
            .toList();
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          body: '$uri: ${response.body}',
          message: 'Failed to load categories',
        );
      }
    });
  }

  static Future<void> saveAccountItem(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    return ApiErrorHandler.wrapRequest(context, () async {
      final Uri uri;
      final http.Response response;

      if (data['id'] != null) {
        uri = Uri.parse('$_baseUrl/api/account/item/${data['id']}');
        response = await http.patch(
          uri,
          headers: _getHeaders(needsContentType: true),
          body: json.encode(data),
        );
      } else {
        uri = Uri.parse('$_baseUrl/api/account/item');
        response = await http.post(
          uri,
          headers: _getHeaders(needsContentType: true),
          body: json.encode(data),
        );
      }

      if (!_isSuccessStatusCode(response.statusCode)) {
        throw ApiException(
          statusCode: response.statusCode,
          body: response.body,
          message: 'Failed to save transaction',
        );
      }
    });
  }

  static Future<List<Map<String, dynamic>>> fetchAccountItems({
    required String accountBookId,
    List<String>? categories,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final Map<String, dynamic> body = {
      'accountBookId': accountBookId,
    };

    if (categories?.isNotEmpty ?? false) body['categories'] = categories;
    if (type != null) body['type'] = type;
    if (startDate != null) body['startDate'] = startDate.toIso8601String();
    if (endDate != null) body['endDate'] = endDate.toIso8601String();

    final uri = Uri.parse('$_baseUrl/api/account/item/list');

    final response = await http.post(
      uri,
      headers: _getHeaders(needsContentType: true),
      body: json.encode(body),
    );

    if (_isSuccessStatusCode(response.statusCode)) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Map<String, dynamic>.from(item)).toList();
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        body: '$uri: ${response.body}',
        message: 'Failed to load account items',
      );
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAccountBooks() async {
    final uri = Uri.parse('$_baseUrl/api/account/book');
    final response = await http.get(
      uri,
      headers: _getHeaders(),
    );

    if (_isSuccessStatusCode(response.statusCode)) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((book) => Map<String, dynamic>.from(book)).toList();
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        body: '$uri: ${response.body}',
        message: 'Failed to load account books',
      );
    }
  }

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final uri = Uri.parse('$_baseUrl/api/auth/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (_isSuccessStatusCode(response.statusCode)) {
      final data = json.decode(response.body);
      final token = data['access_token'];
      setToken(token);
      return {
        'token': token,
        'userInfo': {
          'userId': data['userId'],
          'username': data['username'],
          'nickname': data['nickname'],
        },
      };
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        body: '$uri: ${response.body}',
        message: 'Login failed',
      );
    }
  }

  static Future<void> createAccountBook(
    String name,
    String description, {
    required String currencySymbol,
    required String icon,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/account/book');
    final response = await http.post(
      uri,
      headers: _getHeaders(needsContentType: true),
      body: json.encode({
        'name': name,
        'description': description,
        'currencySymbol': currencySymbol,
        'icon': icon,
      }),
    );

    if (!_isSuccessStatusCode(response.statusCode)) {
      throw ApiException(
        statusCode: response.statusCode,
        body: '$uri: ${response.body}',
        message: 'Failed to create account book',
      );
    }
  }

  static void clearToken() {
    _token = null;
  }

  static Future<void> register({
    required String username,
    required String password,
    required String email,
    String? nickname,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/users/register');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'email': email,
        'nickname': nickname ?? username,
      }),
    );

    if (!_isSuccessStatusCode(response.statusCode)) {
      throw ApiException(
        statusCode: response.statusCode,
        body: '$uri: ${response.body}',
        message: 'Registration failed',
      );
    }
  }

  static Future<void> deleteAccountItem(String id) async {
    final url = Uri.parse('$_baseUrl/api/account/item/$id');
    final response = await http.delete(
      url,
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete account item');
    }
  }

  static Future<String> getApiHost() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_host') ?? _baseUrl;
  }

  static Future<void> setApiHost(String host) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_host', host);
    _baseUrl = host; // 更新当前使用的基础URL
  }

  static Future<List<Map<String, dynamic>>> fetchFundList(
      String accountBookId) async {
    final uri = Uri.parse('$_baseUrl/api/account/fund/listByAccountBookId');
    final response = await http.post(
      uri,
      headers: _getHeaders(needsContentType: true),
      body: json.encode({
        'accountBookId': accountBookId,
      }),
    );

    if (_isSuccessStatusCode(response.statusCode)) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((fund) => Map<String, dynamic>.from(fund)).toList();
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        body: '$uri: ${response.body}',
        message: 'Failed to load fund list',
      );
    }
  }

  /// 编辑账本
  /// [bookId] 账本ID
  /// [data] 更新的数据，包含 name, description, currencySymbol, members 等字段
  static Future<Map<String, dynamic>> updateAccountBook(
    BuildContext context,
    String bookId,
    Map<String, dynamic> data,
  ) async {
    return ApiErrorHandler.wrapRequest(context, () async {
      final uri = Uri.parse('$_baseUrl/api/account/book/$bookId');
      final response = await http.patch(
        uri,
        headers: _getHeaders(needsContentType: true),
        body: json.encode({
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
        }),
      );

      if (_isSuccessStatusCode(response.statusCode)) {
        return {
          'code': 0,
          'data': json.decode(response.body),
          'message': '更新成功',
        };
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          body: '$uri: ${response.body}',
          message: 'Failed to update account book',
        );
      }
    });
  }

  static Future<Map<String, dynamic>> getUserByInviteCode(
    BuildContext context,
    String code,
  ) async {
    return ApiErrorHandler.wrapRequest(context, () async {
      final uri = Uri.parse('$_baseUrl/api/users/invite/$code');
      final response = await http.get(
        uri,
        headers: _getHeaders(),
      );

      if (_isSuccessStatusCode(response.statusCode)) {
        return json.decode(response.body);
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          body: '$uri: ${response.body}',
          message: 'Failed to get user by invite code',
        );
      }
    });
  }

  // 获取当前用户信息
  static Future<Map<String, dynamic>> getLoginUserInfo() async {
    final uri = Uri.parse('$_baseUrl/api/users/current');
    final response = await http.get(
      uri,
      headers: _getHeaders(),
    );

    if (_isSuccessStatusCode(response.statusCode)) {
      return json.decode(response.body);
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        body: '$uri: ${response.body}',
        message: 'Failed to get user info',
      );
    }
  }

  // 保存用户信息
  static Future<Map<String, dynamic>> saveUserInfo({
    String? nickname,
    String? email,
    String? phone,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/users/current');
    final response = await http.put(
      uri,
      headers: _getHeaders(needsContentType: true),
      body: json.encode({
        if (nickname != null) 'nickname': nickname,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
      }),
    );

    if (_isSuccessStatusCode(response.statusCode)) {
      return json.decode(response.body);
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        body: '$uri: ${response.body}',
        message: 'Failed to save user info',
      );
    }
  }

  // 重置邀请码
  static Future<String> resetInviteCode() async {
    final uri = Uri.parse('$_baseUrl/api/users/invite/reset');
    final response = await http.put(
      uri,
      headers: _getHeaders(),
    );

    if (_isSuccessStatusCode(response.statusCode)) {
      final data = json.decode(response.body);
      return data['inviteCode'];
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        body: '$uri: ${response.body}',
        message: 'Failed to reset invite code',
      );
    }
  }

  // 获取商家列表
  static Future<List<Map<String, dynamic>>> fetchShops(
    BuildContext context,
    String accountBookId,
  ) async {
    return ApiErrorHandler.wrapRequest(context, () async {
      final uri = Uri.parse('$_baseUrl/api/account/shop').replace(
        queryParameters: {'accountBookId': accountBookId},
      );

      final response = await http.get(
        uri,
        headers: _getHeaders(),
      );

      if (_isSuccessStatusCode(response.statusCode)) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((shop) => Map<String, dynamic>.from(shop)).toList();
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          body: '$uri: ${response.body}',
          message: '获取商家列表失败',
        );
      }
    });
  }

  // 创建商家
  static Future<Map<String, dynamic>> createShop(
    BuildContext context,
    String name,
    String accountBookId,
  ) async {
    return ApiErrorHandler.wrapRequest(context, () async {
      final uri = Uri.parse('$_baseUrl/api/account/shop');
      final response = await http.post(
        uri,
        headers: _getHeaders(needsContentType: true),
        body: json.encode({
          'name': name,
          'accountBookId': accountBookId,
        }),
      );

      if (_isSuccessStatusCode(response.statusCode)) {
        return Map<String, dynamic>.from(json.decode(response.body));
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          body: '$uri: ${response.body}',
          message: '创建商家失败',
        );
      }
    });
  }

  static Future<Map<String, dynamic>> createCategory(
    BuildContext context,
    String name,
    String accountBookId,
  ) async {
    return ApiErrorHandler.wrapRequest(context, () async {
      final uri = Uri.parse('$_baseUrl/api/account/category');
      final response = await http.post(
        uri,
        headers: _getHeaders(needsContentType: true),
        body: json.encode({
          'name': name,
          'accountBookId': accountBookId,
        }),
      );

      if (_isSuccessStatusCode(response.statusCode)) {
        return Map<String, dynamic>.from(json.decode(response.body));
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          body: '$uri: ${response.body}',
          message: '创建分类失败',
        );
      }
    });
  }

  static Future<Map<String, dynamic>> updateCategory(
    BuildContext context,
    String id,
    String name,
  ) async {
    return ApiErrorHandler.wrapRequest(context, () async {
      final uri = Uri.parse('$_baseUrl/api/account/category/$id');
      final response = await http.patch(
        uri,
        headers: _getHeaders(needsContentType: true),
        body: json.encode({
          'name': name,
        }),
      );

      if (_isSuccessStatusCode(response.statusCode)) {
        return Map<String, dynamic>.from(json.decode(response.body));
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          body: '$uri: ${response.body}',
          message: '更新分类失败',
        );
      }
    });
  }

  static Future<Map<String, dynamic>> updateShop(
    BuildContext context,
    String id,
    String name,
  ) async {
    return ApiErrorHandler.wrapRequest(context, () async {
      final uri = Uri.parse('$_baseUrl/api/account/shop/$id');
      final response = await http.patch(
        uri,
        headers: _getHeaders(needsContentType: true),
        body: json.encode({
          'name': name,
        }),
      );

      if (_isSuccessStatusCode(response.statusCode)) {
        return Map<String, dynamic>.from(json.decode(response.body));
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          body: '$uri: ${response.body}',
          message: '更新商家失败',
        );
      }
    });
  }
}
