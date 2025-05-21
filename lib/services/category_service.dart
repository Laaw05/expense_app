import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryService {
  final _client = Supabase.instance.client;

  /// Thêm danh mục mới
  Future<void> addCategory(Map<String, dynamic> data) async {
    final response = await _client.from('categories').insert(data);
    if (response.error != null) {
      throw response.error!;
    }
  }

  /// Cập nhật danh mục
  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('categories')
        .update(data)
        .eq('id', id);
    if (response.error != null) {
      throw response.error!;
    }
  }

  /// Xoá danh mục
  Future<void> deleteCategory(String id) async {
    final response = await _client
        .from('categories')
        .delete()
        .eq('id', id);
    if (response.error != null) {
      throw response.error!;
    }
  }

  /// Lấy danh sách danh mục theo userId và loại (tiền chi hoặc tiền thu)
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

  /// Lấy tất cả danh mục của user
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
