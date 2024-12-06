import 'package:flutter/material.dart';
import 'account_item_list.dart';
import 'settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'statistics/statistics_page.dart';
import '../l10n/l10n.dart';
import '../constants/storage_keys.dart';
import '../services/storage_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  String? _currentBookId;
  String? _currentBookName;

  @override
  void initState() {
    super.initState();
    _loadCurrentBook();
  }

  Future<void> _loadCurrentBook() async {
    setState(() {
      _currentBookId = StorageService.getString(StorageKeys.currentBookId);
      _currentBookName = StorageService.getString(StorageKeys.currentBookName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    final pages = [
      AccountItemList(
        onBookSelected: (book) {
          _selectBook(book);
        },
      ),
      if (_currentBookId != null)
        const StatisticsPage()
      else
        _buildNoBookSelected(),
      SettingsPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 1 && _currentBookId == null) {
            // 如果点击统计但没有选择账本，显示提示
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.pleaseSelectBook),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.list_alt_outlined),
            selectedIcon: const Icon(Icons.list_alt),
            label: l10n.accountBookList,
          ),
          NavigationDestination(
            icon: const Icon(Icons.analytics_outlined),
            selectedIcon: const Icon(Icons.analytics),
            label: l10n.statistics,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        surfaceTintColor: colorScheme.surfaceTint,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }

  Widget _buildNoBookSelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            L10n.of(context).pleaseSelectBook,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectBook(Map<String, dynamic> book) async {
    await StorageService.setString(StorageKeys.currentBookId, book['id']);
    await StorageService.setString(StorageKeys.currentBookName, book['name']);
    setState(() {
      _currentBookId = book['id'];
      _currentBookName = book['name'];
    });
  }
}
