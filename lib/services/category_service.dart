import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryService {
  final _client = Supabase.instance.client;


  Future<void> addCategory(Map<String, dynamic> data) async {
    final response = await _client.from('categories').insert(data);
    if (response.error != null) {
      throw response.error!;
    }
  }


  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('categories')
        .update(data)
        .eq('id', id);
    if (response.error != null) {
      throw response.error!;
    }
  }


  Future<void> deleteCategory(String id) async {
    final response = await _client
        .from('categories')
        .delete()
        .eq('id', id);
    if (response.error != null) {
      throw response.error!;
    }
  }


  Future<List<Map<String, dynamic>>> getCategoriesByType({
    required String userId,
    required String type,
  }) async {
    final response = await _client
        .from('categories')
        .select()
        .eq('user_id', userId)
        .eq('type', type)
        .order('name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }


  Future<List<Map<String, dynamic>>> getAllCategories(String userId) async {
    final response = await _client
        .from('categories')
        .select()
        .eq('user_id', userId)
        .order('created_at');
    return List<Map<String, dynamic>>.from(response);
  }
  Future<List<Map<String, dynamic>>> fetchCategories(String userId) async {
    final response = await _client
        .from('categories')
        .select()
        .eq('user_id', userId);

    if (response.isEmpty) {
      return [];
    }
    return List<Map<String, dynamic>>.from(response);
  }

}
