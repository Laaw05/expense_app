import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: "https://zeiwkahbgwovpsdsrkiw.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InplaXdrYWhiZ3dvdnBzZHNya2l3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc2NDY1NzcsImV4cCI6MjA2MzIyMjU3N30.01mUhe7nxm0esSgVxLY-vz2G_Yn05yNL7qhMEjMujLI",
    );
  }
}
