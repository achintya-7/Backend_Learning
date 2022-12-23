import 'package:banking_app/feature/auth/binding/auth_bindings.dart';
import 'package:banking_app/feature/auth/view/login_page.dart';
import 'package:banking_app/feature/auth/view/register_page.dart';
import 'package:banking_app/feature/bank_home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Banking App',
      theme: ThemeData(
        primaryColor: Colors.black,
        appBarTheme: const AppBarTheme(color: Colors.black),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
        ),
      ),
      initialRoute: "/login",
      getPages: [
        GetPage(name: "/login", page: () => LoginPage(), binding: AuthBindings()),
        GetPage(name: "/register", page: () => const RegisterPage()),
        GetPage(name: "/home", page: () => const HomePage())
      ],
    );
  }
}
