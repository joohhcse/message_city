import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:message_city/screen/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  await Supabase.initialize(
    url: supabaseUrl.toString(),
    anonKey: supabaseAnonKey.toString(),
  );

  runApp(
    // const MyApp()
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}

