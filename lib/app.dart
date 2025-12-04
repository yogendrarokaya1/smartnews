import 'package:flutter/material.dart';
import 'package:smartnews/screens/splash_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartNews Nepal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 46, 25, 239),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
