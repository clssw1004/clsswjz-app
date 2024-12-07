import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'data/data_source_factory.dart';
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
import 'data/data_source.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/server_config_service.dart';
import 'providers/server_config_provider.dart';
import 'pages/settings/widgets/server_url_dialog.dart';
import 'services/api_config_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化存储服务
  await StorageService.init();

  // 创建数据源
  final dataSource = await DataSourceFactory.create(DataSourceType.http);
  
  // 初始化 API 服务
  ApiService.init(dataSource);
  
  // 初始化 API 配置
  await ApiConfigManager.initialize();
  
  // 初始化其他服务
  AuthService.init(dataSource);
  UserService.init(dataSource);
  await UserService.initializeSession();

  final prefs = await SharedPreferences.getInstance();
  final serverConfigService = ServerConfigService(prefs);

  // 初始化主题
  final themeProvider = ThemeProvider();
  await themeProvider.loadSavedTheme();

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

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: localeProvider),
        Provider<DataSource>.value(value: dataSource),
        ChangeNotifierProvider(
          create: (_) => ServerConfigProvider(serverConfigService),
        ),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          return MaterialApp(
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            title: '记账本',
            routes: {
              '/register': (context) => RegisterPage(),
              '/home': (context) => HomePage(),
              '/server_config': (context) => ServerUrlDialog(),
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
                  future: UserService.hasValidSession().then((hasSession) {
                    return hasSession ? UserService.getUserInfo() : null;
                  }),
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
                    return snapshot.data != null ? HomePage() : LoginPage();
                  },
                );
              },
            ),
          );
        },
      ),
    ),
  );
}
