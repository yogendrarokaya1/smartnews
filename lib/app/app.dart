import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/app/theme/app_theme.dart';
import 'package:smartnews/features/auth/presentation/pages/login_page.dart';
import 'package:smartnews/features/auth/presentation/state/auth_state.dart';
import 'package:smartnews/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:smartnews/features/dashboard/presentation/pages/dashboar_screen.dart';
import 'package:smartnews/features/splash/presentation/pages/splash_screen.dart';

// Global navigator key to allow navigation from anywhere
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to auth state changes and navigate accordingly
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.unauthenticated) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false, // remove ALL previous routes
        );
      } else if (next.status == AuthStatus.authenticated) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
        );
      }
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartNews Nepal',
      theme: AppTheme.lightTheme,
      navigatorKey: navigatorKey,
      home: const SplashScreen(),
    );
  }
}
