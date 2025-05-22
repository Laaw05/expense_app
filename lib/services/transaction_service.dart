import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction.dart';
import '../models/category.dart';

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

  Future<void> updateTransaction(String transactionId,
      Map<String, dynamic> updatedData) async {
    await _client.from('transactions').update(updatedData).eq(
        'id', transactionId);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _client.from('transactions').delete().eq('id', transactionId);
  }

  Future<List<Transaction>> getTransactionsByUser(String userId) async {
    final response = await _client
        .from('transactions')
        .select()
        .eq('user_id', userId)
        .order('date', ascending: false);

    return (response as List).map((e) => Transaction.fromJson(e)).toList();
  }

  /// 🔍 Dùng cho ReportScreen: lấy giao dịch trong khoảng thời gian
  Future<List<Transaction>> fetchTransactionsByDateRange(DateTime start,
      DateTime end) async {
    final response = await _client
        .from('transactions')
        .select()
        .gte('date', start.toIso8601String())
        .lte('date', end.toIso8601String());

    return (response as List).map((e) => Transaction.fromJson(e)).toList();
  }

  Future<List<Category>> fetchAllCategories() async {
    final response = await _client.from('categories').select();
    return (response as List).map((e) => Category.fromJson(e)).toList();
  }

  Future<Map<String, double>> getTotalIncomeAndExpense(String userId) async {
    final response = await _client
        .from('transactions')
        .select('type, amount')
        .eq('user_id', userId);

    double income = 0.0;
    double expense = 0.0;

    for (final item in response) {
      if (item['type'] == 'income') {
        income += (item['amount'] as num).toDouble();
      } else if (item['type'] == 'expense') {
        expense += (item['amount'] as num).toDouble();
      }
    }

    return {
      'income': income,
      'expense': expense,
    };
  }

}