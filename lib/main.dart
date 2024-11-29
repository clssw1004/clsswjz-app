import 'package:flutter/material.dart';
import "pages/login_page.dart";
import 'pages/home_page.dart';
import 'pages/register_page.dart';
import 'theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.loadSavedTheme();
  
  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        // 先创建一个基础的 MaterialApp 配置
        final materialApp = MaterialApp(
          title: '记账本',
          theme: ThemeData(
            primarySwatch: MaterialColor(
              themeProvider.themeColor.value,
              <int, Color>{
                50: themeProvider.themeColor.withOpacity(0.1),
                100: themeProvider.themeColor.withOpacity(0.2),
                200: themeProvider.themeColor.withOpacity(0.3),
                300: themeProvider.themeColor.withOpacity(0.4),
                400: themeProvider.themeColor.withOpacity(0.5),
                500: themeProvider.themeColor.withOpacity(0.6),
                600: themeProvider.themeColor.withOpacity(0.7),
                700: themeProvider.themeColor.withOpacity(0.8),
                800: themeProvider.themeColor.withOpacity(0.9),
                900: themeProvider.themeColor.withOpacity(1.0),
              },
            ),
          ),
          routes: {
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/home') {
              final userInfo = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => HomePage(userInfo: userInfo),
              );
            }
            return null;
          },
        );

        return FutureBuilder<Map<String, dynamic>?>(
          future: _initializeApp(),
          builder: (context, snapshot) {
            // 如果正在加载，显示加载页面
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MaterialApp(
                theme: materialApp.theme,
                home: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: themeProvider.themeColor,
                    ),
                  ),
                ),
              );
            }

            // 根据是否有用户信息返回不同的页面
            return MaterialApp(
              title: materialApp.title,
              theme: materialApp.theme,
              routes: materialApp.routes ?? {}, // 添加空map作为默认值
              onGenerateRoute: materialApp.onGenerateRoute,
              home: snapshot.data != null 
                  ? HomePage(userInfo: snapshot.data!)  // 有用户信息直接进入主页
                  : LoginPage(),  // 没有用户信息进入登录页
            );
          },
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _initializeApp() async {
    try {
      final hasSession = await UserService.hasValidSession();
      if (hasSession) {
        await UserService.initializeSession();
        return await UserService.getUserInfo();
      }
      return null;
    } catch (e) {
      print('初始化应用失败: $e');
      return null;
    }
  }
}


