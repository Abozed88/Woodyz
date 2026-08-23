import 'package:flutter/material.dart';
import 'package:woodyz/config/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:woodyz/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Secrets.supabase_url,
    publishableKey: Secrets.supabase_anon_key,
  );

  runApp(const MyApp());
}
