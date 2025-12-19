import 'package:flutter/material.dart';
import 'package:smartnews/screens/splash_screen.dart';
import 'package:smartnews/theme/app_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartNews Nepal',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
