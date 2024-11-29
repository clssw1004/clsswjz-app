import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'http://192.168.2.199:3000';
  static String? _token;

  static void setToken(String token) {
    _token = token;
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

  static Future<List<String>> fetchCategories(String accountBookId) async {
    final uri = Uri.parse('$_baseUrl/api/account/category').replace(
      queryParameters: {'accountBookId': accountBookId},
    );

    final response = await http.get(
      uri,
      headers: _getHeaders(),
    );

    if (_isSuccessStatusCode(response.statusCode)) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((category) => category['name'].toString()).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<void> saveAccountItem(Map<String, dynamic> data,
      {String? id}) async {
    final Uri uri;
    final http.Response response;

    if (id != null) {
      uri = Uri.parse('$_baseUrl/api/account/item/$id');
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
      throw Exception('Failed to save transaction');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAccountItems({
    String? accountBookId,
    String? category,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, String>{};

    if (accountBookId != null) queryParams['accountBookId'] = accountBookId;
    if (category != null) queryParams['category'] = category;
    if (type != null) queryParams['type'] = type;
    if (startDate != null) {
      queryParams['startDate'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['endDate'] = endDate.toIso8601String();
    }

    final uri = Uri.parse('$_baseUrl/api/account/item').replace(
      queryParameters: queryParams,
    );

    final response = await http.get(
      uri,
      headers: _getHeaders(),
    );

    if (_isSuccessStatusCode(response.statusCode)) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Map<String, dynamic>.from(item)).toList();
    } else {
      throw Exception('Failed to load account items');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAccountBooks() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/account/book'),
      headers: _getHeaders(),
    );

    if (_isSuccessStatusCode(response.statusCode)) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((book) => Map<String, dynamic>.from(book)).toList();
    } else {
      throw Exception('Failed to load account books');
    }
  }

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/login'),
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
      throw Exception('Login failed');
    }
  }

  static Future<void> createAccountBook(String name, String description) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/account/book'),
      headers: _getHeaders(needsContentType: true),
      body: json.encode({
        'name': name,
        'description': description,
      }),
    );

    if (!_isSuccessStatusCode(response.statusCode)) {
      throw Exception('Failed to create account book');
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
    final response = await http.post(
      Uri.parse('$_baseUrl/api/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'email': email,
        'nickname': nickname ?? username,
      }),
    );

    if (!_isSuccessStatusCode(response.statusCode)) {
      throw Exception('Registration failed');
    }
  }

  static Future<void> deleteAccountItem(String id) async {
    final url = Uri.parse('$_baseUrl/api/account/item/$id');
    final response = await http.delete(
      url,
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete account item');
    }
  }
}
