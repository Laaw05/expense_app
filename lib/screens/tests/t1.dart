import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/transaction_service.dart';

Future<void> handleAddTransaction({
  required String categoryId,
  required double amount,
  required String type,
  required String note,
  required DateTime date,
}) async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    Get.snackbar('Lỗi', 'Bạn chưa đăng nhập');
    return;
  }

  if (amount <= 0) {
    Get.snackbar('Lỗi', 'Số tiền phải lớn hơn 0');
    return;
  }

  try {
    await TransactionService().addTransaction(
      userId: user.id,
      categoryId: categoryId,
      amount: amount,
      type: type,
      note: note,
      date: date,
    );

    Get.snackbar('Thành công', 'Giao dịch đã được thêm');
    Get.back(); // hoặc Navigator.pop(context);
  } catch (e) {
    Get.snackbar('Lỗi', 'Thêm giao dịch thất bại: $e');
  }
}
