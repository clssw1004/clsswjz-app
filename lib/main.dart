import 'package:flutter/material.dart';
import "pages/login_page.dart";
import 'pages/home_page.dart';
import 'pages/register_page.dart';
import 'pages/create_account_book_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '记账应用',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  }
}


