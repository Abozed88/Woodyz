import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/view/explore.dart';
import 'package:woodyz/features/auth/view/login.dart';
import 'package:woodyz/features/auth/view/signup.dart';
import 'test1.dart';
import 'package:provider/provider.dart';

void main() {
  // ChangeNotifierProvider(create: (b) => ConfirmProvider(),
  runApp(MyApp());
}

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