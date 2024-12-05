import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "pages/login_page.dart";
import 'pages/home_page.dart';
import 'pages/register_page.dart';
import 'pages/user/user_info_page.dart';
import 'theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'services/user_service.dart';
import 'pages/account_book_list.dart';
import 'pages/create_account_book_page.dart';
import 'package:flutter/services.dart';
import 'providers/locale_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/app_localizations.dart';

Future<Map<String, dynamic>?> _initializeApp() async {
  try {
    final hasSession = await UserService.hasValidSession();
    if (hasSession) {
      await UserService.initializeSession();
      return UserService.getUserInfo();
    }
    return null;
  } catch (e) {
    print('初始化应用失败: $e');
    return null;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 加载主题
  final themeProvider = ThemeProvider();
  await themeProvider.loadSavedTheme();

  // 加载语言设置
  final localeProvider = LocaleProvider();
  await localeProvider.loadSavedLocale();

  if (!kIsWeb && Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    );

    // 启用 Android 返回手势
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
  }

  runApp(
    Builder(
      builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: themeProvider),
            ChangeNotifierProvider.value(value: localeProvider),
          ],
          child: Consumer2<ThemeProvider, LocaleProvider>(
            builder: (context, themeProvider, localeProvider, _) {
              return MaterialApp(
                theme: themeProvider.lightTheme,
                darkTheme: themeProvider.darkTheme,
                themeMode: themeProvider.themeMode,
                title: '记账本',
                routes: {
                  '/login': (context) => LoginPage(),
                  '/register': (context) => RegisterPage(),
                  '/account-books': (context) => AccountBookList(),
                  '/create-account-book': (context) => CreateAccountBookPage(),
                  '/user-info': (context) => UserInfoPage(),
                },
                onGenerateRoute: (settings) {
                  if (settings.name == '/home') {
                    return MaterialPageRoute(
                      builder: (context) => HomePage(),
                    );
                  }
                  return null;
                },
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('zh'),
                  Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
                  Locale('en'),
                ],
                locale: localeProvider.locale,
                home: Builder(
                  builder: (context) {
                    return FutureBuilder<Map<String, dynamic>?>(
                      future: _initializeApp(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(
                                color: themeProvider.themeColor,
                              ),
                            ),
                          );
                        }
                        return snapshot.data != null ? HomePage() : LoginPage();
                      },
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    ),
  );
}
