import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/categories/default_cat.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<User?> signIn(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user;
    } on AuthException catch (e) {
      print('Login error: ${e.message}');
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response.user;
    } on AuthException catch (e) {
      print('Register error: ${e.message}');
      return null;
    }
  }
}
