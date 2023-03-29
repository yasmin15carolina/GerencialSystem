import 'dart:io';

import 'package:finantial_manager/helpers/theme_manager.dart';
import 'package:finantial_manager/views/home.view.dart';
import 'package:finantial_manager/views/login.view.dart';
import 'package:finantial_manager/views/signup.view.dart';
import 'package:finantial_manager/views/transaction.view.dart';
import 'package:finantial_manager/views/welcome.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  //apenas para rodas a api local
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await MyApp.init();
  runApp(const MyApp());
}

late SharedPreferences localStorage;
late ThemeManager themeManager;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
    themeManager = ThemeManager();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finantial Manager',
        themeMode: themeManager.themeMode,
        theme: ThemeData(
          // primarySwatch: Colors.red,
          useMaterial3: true,
          colorSchemeSeed: const Color(0xff6750a4),
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 20),
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xff6750a4),
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 20),
          brightness: Brightness.dark,
        ),
        home: WelcomeView());
  }
}

//apenas para rodar a api local
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
