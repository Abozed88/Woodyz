import 'package:flutter/material.dart';
import 'package:woodyz/core/theme/app_theme.dart';
import 'package:woodyz/features/auth/presentation/pages/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "woodyz",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const Login(),
    );
  }
}
