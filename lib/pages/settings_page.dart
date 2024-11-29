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
    final themeColor = Provider.of<ThemeProvider>(context).themeColor;
    return CircleAvatar(
      radius: 30,
      backgroundColor: themeColor.withOpacity(0.1),
      child: Text(
        nickname.isNotEmpty ? nickname[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: 24,
          color: themeColor,
          fontWeight: FontWeight.w500,
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

  void _showApiHostDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    // 获取当前的API地址
    ApiService.getApiHost().then((currentHost) {
      controller.text = currentHost;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('设置后台服务地址'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: '服务器地址',
                  hintText: '例如: http://example.com:8080',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 8),
              Text(
                '注意: 修改服务器地址后需要重新登录',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('确定'),
              onPressed: () async {
                final newHost = controller.text.trim();
                if (newHost.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('服务器地址不能为空')),
                  );
                  return;
                }
                
                // 保存新的API地址
                await ApiService.setApiHost(newHost);
                
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('服务器地址已更新，请重新登录')),
                );
                
                // 清空token并返回登录页
                ApiService.clearToken();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    ).then((_) {
      controller.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final themeColor = themeProvider.themeColor;
        return Scaffold(
          appBar: AppBar(
            title: Text('设置'),
            elevation: 0,
          ),
          body: ListView(
            children: [
              // 用户信息卡片
              Card(
                margin: EdgeInsets.all(16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildUserAvatar(context, userInfo['nickname'] ?? ''),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userInfo['nickname'] ?? userInfo['username'] ?? '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              userInfo['username'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
              // 添加后台服务设置
              ListTile(
                leading: Icon(Icons.dns),
                title: Text('后台服务设置'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => _showApiHostDialog(context),
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
      },
    );
  }
}
