import 'package:flutter/material.dart';
import 'account_item_list.dart';
import 'settings_page.dart';
import 'account_item_info.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  const HomePage({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      AccountItemList(),
      Center(child: Text('统计')), // 待实现
      SettingsPage(userInfo: widget.userInfo),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '账目',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '统计',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountItemForm(),
                  ),
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
} 