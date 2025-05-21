import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileService {
  final _client = Supabase.instance.client;

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response = await _client
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .single();
    return response;
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    final response = await _client
        .from('user_profiles')
        .update(data)
        .eq('id', userId);
    if (response.error != null) {
      throw response.error!;
    }
  }
}
