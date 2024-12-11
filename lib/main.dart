import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'data/data_source_factory.dart';
import 'l10n/app_localizations.dart';
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
    _checkFuture = _checkServerAndSession();
  }

  Future<bool> _checkServerAndSession() async {
    try {
      // 设置较短的超时时间
      await Future.any([
        ApiService.checkServerStatus(),
        Future.delayed(const Duration(seconds: 3), () {
          throw TimeoutException('Server check timeout');
        }),
      ]);

      // 服务器正常后，再初始化会话
      await UserService.initializeSession();

      // 最后检查会话是否有效
      return await UserService.hasValidSession();
    } catch (e) {
      print('Server status check failed: $e');
      return false;
    }
  }

  Future<void> _handleCheckFailure() async {
    final shouldRetry = await _showServerCheckFailedDialog();
    if (shouldRetry) {
      setState(() {
        _checkFuture = _checkServerAndSession();
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

        if (snapshot.data != true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleCheckFailure();
          });
          return _buildLoadingScreen(context);
        }

        return HomePage();
      },
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: widget.themeProvider.themeColor,
            ),
            const SizedBox(height: 16),
            Text(
              L10n.of(context).checkingServerStatus,
              style: TextStyle(
                color: widget.themeProvider.themeColor,
                fontSize: 16,
              ),
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
            title: '记账本',
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
