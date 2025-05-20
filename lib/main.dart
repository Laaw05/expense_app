import 'package:expense_app/pages/auth/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://zeiwkahbgwovpsdsrkiw.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InplaXdrYWhiZ3dvdnBzZHNya2l3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc2NDY1NzcsImV4cCI6MjA2MzIyMjU3N30.01mUhe7nxm0esSgVxLY-vz2G_Yn05yNL7qhMEjMujLI");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
    );

  }
}