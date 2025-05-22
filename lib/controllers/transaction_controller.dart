import 'package:get/get.dart';
import '../services/transaction_service.dart';

class TransactionController extends GetxController {
  final TransactionService _service = TransactionService();

  var totalIncome = 0.0.obs;
  var totalExpense = 0.0.obs;
  var isLoading = false.obs;

  Future<void> fetchTotals(String userId) async {
    isLoading.value = true;
    final totals = await _service.getTotalIncomeAndExpense(userId);
    totalIncome.value = totals['income'] ?? 0.0;
    totalExpense.value = totals['expense'] ?? 0.0;
    isLoading.value = false;
  }
}
