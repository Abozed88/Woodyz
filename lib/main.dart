import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woodyz/config/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:woodyz/app.dart';
import 'package:woodyz/core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Secrets.supabase_url,
    publishableKey: Secrets.supabase_anon_key,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}
