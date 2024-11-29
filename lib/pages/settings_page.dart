import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/data_service.dart';
import '../theme/theme_manager.dart';
import '../theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  final Map<String, dynamic> userInfo;
  final DataService _dataService = DataService();

  SettingsPage({required this.userInfo});

  Widget _buildUserAvatar(BuildContext context, String nickname) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        nickname.isNotEmpty ? nickname[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确认注销'),
          content: Text('确定要注销当前账户吗？'),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                '确定',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                // 清空token
                ApiService.clearToken();
                // 返回登录页面，并清空导航栈
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showThemeColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return AlertDialog(
              title: Text('选择主题色'),
              content: Container(
                width: double.maxFinite,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ThemeManager.themeColors.map((color) {
                    return InkWell(
                      onTap: () {
                        themeProvider.setThemeColor(color);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('主题色已更新')),
                        );
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color == themeProvider.themeColor 
                                ? Colors.black 
                                : Colors.grey[300]!,
                            width: color == themeProvider.themeColor ? 3 : 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设置')),
      body: ListView(
        children: [
          // 用户信息
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                _buildUserAvatar(context, userInfo['nickname'] ?? ''),
                SizedBox(width: 16),
                Text(
                  userInfo['nickname'] ?? userInfo['username'] ?? '',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Divider(),
          // 新增账本
          ListTile(
            leading: Icon(Icons.add_box),
            title: Text('新增账本'),
            onTap: () {
              Navigator.pushNamed(context, '/create-account-book').then((_) {
                _dataService.fetchAccountBooks(forceRefresh: true);
              });
            },
          ),
          // 主题设置
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('主题设置'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => _showThemeColorPicker(context),
          ),
          // 注销账户
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('注销账户'),
            onTap: () => _logout(context),
          ),

          Divider(),
        ],
      ),
    );
  }
}
