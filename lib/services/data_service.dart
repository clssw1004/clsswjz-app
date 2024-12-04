import '../models/models.dart';
import './api_service.dart';

class DataService {
  static Future<List<AccountBook>> getAccountBooks(
      {bool forceRefresh = false}) {
    return ApiService.getAccountBooks();
  }

  static Future<List<Category>> getCategories(String bookId,
      {bool forceRefresh = false}) {
    return ApiService.getCategories(bookId);
  }

  static Future<List<AccountItem>> getAccountItems(
    String bookId, {
    List<String>? categories,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ApiService.getAccountItems(
      bookId,
      categories: categories,
      type: type,
      startDate: startDate,
      endDate: endDate,
    );
  }

  static Future<List<AccountBookFund>> getBookFunds(String bookId) {
    return ApiService.getBookFunds(bookId);
  }
}
