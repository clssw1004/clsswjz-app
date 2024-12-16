import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'constants/storage_keys.dart';
import 'data/data_source_factory.dart';
import 'l10n/app_localizations.dart';
import "pages/login_page.dart";
import 'pages/home_page.dart';
import 'pages/register_page.dart';
import 'pages/settings/server_management_page.dart';
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
import 'pages/account_item/providers/account_item_provider.dart';

class ServerCheckScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const ServerCheckScreen({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);

  @override
  State<ServerCheckScreen> createState() => _ServerCheckScreenState();
}

class _ServerCheckScreenState extends State<ServerCheckScreen> {
  late Future<bool> _checkFuture;

  @override
  void initState() {
    super.initState();
    _checkFuture = _checkInitialState();
  }

  // 检查初始状态
  Future<bool> _checkInitialState() async {
    // 检查是否有服务器配置
    final serverUrl = StorageService.getString(StorageKeys.serverUrl);
    if (serverUrl.isEmpty) {
      return false;
    }

    return _checkServerStatus();
  }

  // 只检查服务器状态
  Future<bool> _checkServerStatus() async {
    try {
      // 设置较短的超时时间
      await Future.any([
        ApiService.checkServerStatus(),
        Future.delayed(const Duration(seconds: 5), () {
          throw TimeoutException('Server check timeout');
        }),
      ]);
      return true;
    } catch (e) {
      print('Server status check failed: $e');
      return false;
    }
  }

  Future<void> _handleCheckFailure() async {
    final shouldRetry = await _showServerCheckFailedDialog();
    if (shouldRetry) {
      setState(() {
        _checkFuture = _checkServerStatus();
      });
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
      }
    }
  }

  Future<bool> _showServerCheckFailedDialog() async {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.serverCheckFailed),
        content: Text(l10n.serverCheckFailedMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.backToLogin),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.retry),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen(context);
        }
        // 如果没有服务器配置或服务器检查失败
        if (snapshot.data != true) {
          // 如果没有服务器配置，直接跳转登录页
          if (StorageService.getString(StorageKeys.serverUrl).isEmpty) {
            return LoginPage();
          }

          // 否则显示服务器检查失败对话框
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleCheckFailure();
          });
          return _buildLoadingScreen(context);
        }

        // 服务器正常，检查会话状态
        return FutureBuilder<bool>(
          future: StorageService.getString(StorageKeys.token).isEmpty
              ? Future.value(false) // 如果没有 token，直接返回 false
              : UserService.initializeSession(), // 有 token 才去验证会话
          builder: (context, sessionSnapshot) {
            if (sessionSnapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingScreen(context);
            }

            // 如果会话无效，直接跳转到登录页
            if (sessionSnapshot.data != true) {
              return LoginPage();
            }

            // 服务器正常且会话有效，进入主页
            return HomePage();
          },
        );
      },
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/app_logo.png',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // 加载指示器和状态文本
            Column(
              children: [
                CircularProgressIndicator(
                  color: widget.themeProvider.themeColor,
                ),
                const SizedBox(height: 16),
                Text(
                  L10n.of(context).checkingServerStatus,
                  style: TextStyle(
                    color: widget.themeProvider.themeColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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

  // 初始化认证服务（但不检查会话）
  AuthService.init(dataSource);
  await UserService.init();

  final prefs = await SharedPreferences.getInstance();
  final serverConfigService = ServerConfigService();

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
        ChangeNotifierProvider(
          create: (_) => AccountItemProvider(),
        ),
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
            title: 'CLSSWJZ',
            home: Builder(
              builder: (context) => ServerCheckScreen(
                themeProvider: themeProvider,
              ),
            ),
            routes: {
              '/register': (context) => RegisterPage(),
              '/home': (context) => HomePage(),
              '/server_config': (context) => ServerUrlDialog(),
              '/account-books': (context) => AccountBookList(),
              '/create-account-book': (context) => CreateAccountBookPage(),
              '/user-info': (context) => UserInfoPage(),
              '/server-settings': (context) => ServerManagementPage(),
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
          );
        },
      ),
    ),
  );
}
