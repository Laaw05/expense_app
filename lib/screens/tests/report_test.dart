import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/transaction_controller.dart';

class TotalOverviewScreen extends StatelessWidget {
  final String userId;

  TotalOverviewScreen({super.key, required this.userId});

  final TransactionController controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    controller.fetchTotals(userId);

    return Scaffold(
      appBar: AppBar(title: const Text('Tổng Thu & Chi')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBox(
                title: 'Tổng Thu',
                amount: controller.totalIncome.value,
                color: Colors.green,
                formatter: formatter,
              ),
              const SizedBox(height: 20),
              _buildBox(
                title: 'Tổng Chi',
                amount: controller.totalExpense.value,
                color: Colors.red,
                formatter: formatter,
              ),
              const SizedBox(height: 20),
              _buildBox(
                title: 'Cân đối',
                amount: controller.totalIncome.value - controller.totalExpense.value,
                color: Colors.blue,
                formatter: formatter,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBox({
    required String title,
    required double amount,
    required Color color,
    required NumberFormat formatter,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            formatter.format(amount),
            style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
