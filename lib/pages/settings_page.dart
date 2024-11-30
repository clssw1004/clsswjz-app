import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/data_service.dart';
import '../services/user_service.dart';
import '../theme/theme_manager.dart';
import '../theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  final Map<String, dynamic> userInfo;
  final DataService _dataService = DataService();

  SettingsPage({required this.userInfo});

  Widget _buildUserAvatar(BuildContext context, String nickname) {
    final themeColor = Theme.of(context).primaryColor;
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

  void _signOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确认退出'),
          content: Text('确定要退出登录吗？'),
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
              onPressed: () async {
                try {
                  // 使用 UserService 清除会话信息
                  await UserService.clearSession();
                  
                  // 返回登录页面，并清空导航栈
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('退出登录失败: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showThemeColorPicker(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '主题设置',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '选择您喜欢的主题色和显示模式',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          content: Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: ThemeManager.themeColors.map((color) {
                      return InkWell(
                        onTap: () {
                          themeProvider.setThemeColor(color);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color == themeColor 
                                  ? Colors.white 
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: color == themeColor
                              ? Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
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
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    // 用户信息卡片
                    Card(
                      margin: EdgeInsets.all(16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
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
                                      color: Theme.of(context).textTheme.titleLarge?.color,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    userInfo['username'] ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).textTheme.bodyMedium?.color,
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
                    // 深色模式设置
                    ListTile(
                      leading: Icon(Icons.dark_mode),
                      title: Text('深色模式'),
                      trailing: DropdownButton<ThemeMode>(
                        value: themeProvider.themeMode,
                        underline: SizedBox(),
                        items: [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text('跟随系统'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text('浅色'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text('深色'),
                          ),
                        ],
                        onChanged: (ThemeMode? mode) {
                          if (mode != null) {
                            themeProvider.setThemeMode(mode);
                          }
                        },
                      ),
                    ),
                    // 主题设置
                    ListTile(
                      leading: Icon(Icons.color_lens),
                      title: Text('主题颜色'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => _showThemeColorPicker(context),
                    ),
                    // 后台服务设置
                    ListTile(
                      leading: Icon(Icons.dns),
                      title: Text('后台服务设置'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => _showApiHostDialog(context),
                    ),
                  ],
                ),
              ),
              // 退出登录按钮固定在底部
              Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _signOut(context),
                    icon: Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 20,
                    ),
                    label: Text(
                      '退出登录',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
