import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionService {
  final _client = Supabase.instance.client;

  Future<void> addTransaction({
    required String userId,
    required String categoryId,
    required double amount,
    required String type,
    required String note,
    required DateTime date,
  }) async {
    await _client.from('transactions').insert({
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'type': type,
      'note': note,
      'date': date.toIso8601String(),
    });
  }

  Future<void> updateTransaction(String transactionId, Map<String, dynamic> updatedData) async {
    await _client.from('transactions').update(updatedData).eq('id', transactionId);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _client.from('transactions').delete().eq('id', transactionId);
  }

  Future<List<Map<String, dynamic>>> getTransactionsByUser(String userId) async {
    final response = await _client
        .from('transactions')
        .select()
        .eq('user_id', userId)
        .order('date', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
