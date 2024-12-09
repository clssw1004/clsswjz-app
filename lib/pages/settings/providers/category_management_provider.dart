import 'package:flutter/material.dart';
import '../../../models/category.dart';
import '../../../data/data_source.dart';

class CategoryManagementProvider extends ChangeNotifier {
  final DataSource _dataSource;
  String _selectedType = 'EXPENSE';
  List<Category> _categories = [];
  bool _loading = false;
  String? _error;

  CategoryManagementProvider(this._dataSource);

  String get selectedType => _selectedType;
  List<Category> get categories => _categories
      .where((c) => c.categoryType == _selectedType)
      .toList(growable: false);
  bool get loading => _loading;
  String? get error => _error;

  void setSelectedType(String type) {
    if (_selectedType != type) {
      print('Changing type from $_selectedType to $type');
      _selectedType = type;
      print('Filtered categories: ${categories.length}');
      notifyListeners();
    }
  }

  Future<void> loadCategories(String bookId) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final List<Category> loadedCategories =
          await _dataSource.getCategories(bookId);

      _categories = loadedCategories.map((category) {
        if (category.categoryType.isEmpty) {
          return category.copyWith(categoryType: 'EXPENSE');
        }
        return category;
      }).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> createCategory(Category category) async {
    try {
      final newCategory = await _dataSource.createCategory(category);
      _categories.add(newCategory);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCategory(String id, Category category) async {
    try {
      final updatedCategory = await _dataSource.updateCategory(id, category);
      final index = _categories.indexWhere((c) => c.id == id);
      if (index != -1) {
        _categories[index] = updatedCategory;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCategory(String id) async {
    // try {
    //   await _dataSource.deleteCategory(id);
    //   _categories.removeWhere((c) => c.id == id);
    //   notifyListeners();
    // } catch (e) {
    //   rethrow;
    // }
  }
}
