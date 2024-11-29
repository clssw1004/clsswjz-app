import 'package:flutter/material.dart';
import "pages/login_page.dart";
import 'pages/home_page.dart';
import 'pages/register_page.dart';
import 'pages/create_account_book_page.dart';
import 'theme/theme_provider.dart';
import 'package:provider/provider.dart';

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
        return MaterialApp(
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
          initialRoute: '/login',
          routes: {
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/create-account-book': (context) => CreateAccountBookPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/home') {
              final userInfo = settings.arguments as Map<String, dynamic>?;
              if (userInfo == null) {
                return MaterialPageRoute(
                  builder: (context) => LoginPage(),
                );
              }
              return MaterialPageRoute(
                builder: (context) => HomePage(userInfo: userInfo),
              );
            }
            return null;
          },
        );
      },
    );
  }
}


