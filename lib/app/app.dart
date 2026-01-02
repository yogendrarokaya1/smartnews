import 'package:flutter/material.dart';
import 'package:smartnews_v2/app/theme/app_theme.dart';
import 'package:smartnews_v2/features/splash/presentation/pages/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
