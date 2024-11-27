import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'http://192.168.2.147:3000';

  static bool _isSuccessStatusCode(int statusCode) {
    return statusCode == 200 || statusCode == 201;
  }

  static Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/account/category'));
    if (_isSuccessStatusCode(response.statusCode)) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((category) => category['name'].toString()).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<void> saveAccountItem(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/account/item'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (!_isSuccessStatusCode(response.statusCode)) {
      throw Exception('Failed to save transaction');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAccountItems() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/account/item'));
    if (_isSuccessStatusCode(response.statusCode)) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Map<String, dynamic>.from(item)).toList();
    } else {
      throw Exception('Failed to load account items');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAccountBooks() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/account/book'));
    if (_isSuccessStatusCode(response.statusCode)) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((book) => Map<String, dynamic>.from(book)).toList();
    } else {
      throw Exception('Failed to load account books');
    }
  }
} 