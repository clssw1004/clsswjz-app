import 'package:flutter/material.dart';
import "pages/login_page.dart";
import 'pages/home_page.dart';
import 'pages/register_page.dart';
import 'theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'services/user_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.loadSavedTheme();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            title: '记账本',
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
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('zh', 'CN'),
              Locale('en', 'US'),
            ],
            locale: const Locale('zh', 'CN'),
            home: FutureBuilder<Map<String, dynamic>?>(
              future: _initializeApp(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: themeProvider.themeColor,
                      ),
                    ),
                  );
                }
                return snapshot.data != null 
                    ? HomePage(userInfo: snapshot.data!)
                    : LoginPage();
              },
            ),
          );
        },
      ),
    ),
  );
}


