import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/category_service.dart';
import '../../routes/app_routes.dart';
import '../profile/u_profile.dart';
import '../report/report_screen.dart';
import '../../controllers/home_controller.dart';
import '../../screens/settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  final List<Widget> _screens = [
    const HomeContent(),
    ReportScreen(),
    const UserProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: _screens[controller.selectedIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.changeIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    ));
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String selectedType = 'expense';
  late Future<List<Map<String, dynamic>>> _futureCategories;

  String? selectedCategoryId;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController amountController = TextEditingController(text: '0');

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadCategories();

    dateController.text = _formatDate(selectedDate);
  }

  void loadCategories() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      _futureCategories = CategoryService().getCategoriesByType(
          userId: userId, type: selectedType);
    } else {
      _futureCategories = Future.value([]);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} (Th ${date.weekday})";
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    bool isSelected = category['id'] == selectedCategoryId;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategoryId = category['id'];
        });
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isSelected
              ? BorderSide(color: Colors.blue, width: 2)
              : BorderSide(color: Colors.transparent),
        ),
        color: isSelected ? Colors.blue.shade50 : Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.category, color: Colors.blue, size: 30),
              const SizedBox(height: 4),
              Text(
                category['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = _formatDate(picked);
      });
    }
  }

  void _onSubmit() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      Get.snackbar('Lỗi', 'Bạn chưa đăng nhập');
      return;
    }
    if (selectedCategoryId == null) {
      Get.snackbar('Lỗi', 'Vui lòng chọn danh mục');
      return;
    }

    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      Get.snackbar('Lỗi', 'Vui lòng nhập số tiền hợp lệ');
      return;
    }

    final note = noteController.text.trim();

    final newTransaction = {
      'user_id': userId,
      'category_id': selectedCategoryId,
      'amount': amount,
      'note': note,
      'type': selectedType,
      'date': selectedDate.toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
    };

    final response = await Supabase.instance.client
        .from('transactions')
        .insert(newTransaction);

    if (response.error != null) {
      Get.snackbar('Lỗi', 'Không thể lưu giao dịch: ${response.error!.message}');
    } else {
      Get.snackbar('Thành công', 'Đã lưu giao dịch');
      // Reset form
      setState(() {
        noteController.clear();
        amountController.text = '0';
        selectedCategoryId = null;
        selectedDate = DateTime.now();
        dateController.text = _formatDate(selectedDate);
        loadCategories();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedType = 'expense';
                          selectedCategoryId = null;
                          loadCategories();
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedType == 'expense'
                            ? Colors.blue
                            : Colors.grey.shade200,
                      ),
                      child: Text('Tiền chi',
                          style: TextStyle(
                            color: selectedType == 'expense'
                                ? Colors.white
                                : Colors.black,
                          )),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedType = 'income';
                          selectedCategoryId = null;
                          loadCategories();
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedType == 'income'
                            ? Colors.blue
                            : Colors.grey.shade200,
                      ),
                      child: Text('Tiền thu',
                          style: TextStyle(
                            color: selectedType == 'income'
                                ? Colors.white
                                : Colors.black,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Ngày',
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              readOnly: true,
              onTap: _pickDate,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Ghi chú',
                hintText: 'Chưa nhập vào',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: selectedType == 'expense' ? 'Tiền chi' : 'Tiền thu',
                suffixText: 'đ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi tải danh mục: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Không có danh mục nào'));
                  }

                  final categories = snapshot.data!;
                  final totalItems = categories.length + 1;

                  return GridView.builder(
                    itemCount: totalItems,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      if (index == categories.length) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.expenseCat);
                          },
                          child: Card(
                            color: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Chỉnh sửa',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      final category = categories[index];
                      return _buildCategoryItem(category);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    selectedType == 'expense' ? 'Nhập khoản chi' : 'Nhập khoản thu',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
