import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/pages/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "woodyz",
      home: Login(),
    );
  }
}
