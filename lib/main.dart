import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/app/app.dart';
import 'package:smartnews/core/services/hive/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // initialize Hive or other services if needed
  await HiveService().init();

  // // Initialize SharedPreferences : because this is async operation
  // // but riverpod providers are sync so we need to initialize it here
  // final sharedPreferences = await SharedPreferences.getInstance();

  runApp(const ProviderScope(child: MyApp()));
}
