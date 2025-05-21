import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/category_service.dart';
import '../../routes/app_routes.dart';
import '../profile/u_profile.dart';
import '../../controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  final List<Widget> _screens = const [
    HomeContent(),
    Center(child: Text('Report Screen')),
    UserProfileScreen(),
    Center(child: Text('Settings Screen')),
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

  @override
  void initState() {
    super.initState();
    loadCategories();
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

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    IconData iconData;
    Color iconColor;
    switch (category['name'].toLowerCase()) {
      case 'food':
        iconData = Icons.fastfood;
        iconColor = Colors.orange;
        break;
      case 'daily expense':
        iconData = Icons.local_grocery_store;
        iconColor = Colors.green;
        break;
      case 'clothes':
        iconData = Icons.checkroom;
        iconColor = Colors.blue;
        break;
      case 'social fee':
        iconData = Icons.people;
        iconColor = Colors.brown;
        break;
      case 'shopping':
        iconData = Icons.shopping_bag;
        iconColor = Colors.pink;
        break;
      case 'energy fee':
        iconData = Icons.lightbulb;
        iconColor = Colors.orange;
        break;
      case 'oil/gasoline':
        iconData = Icons.local_gas_station;
        iconColor = Colors.teal;
        break;
      case 'contact fee':
        iconData = Icons.phone;
        iconColor = Colors.red;
        break;
      case 'monthly fee':
        iconData = Icons.home;
        iconColor = Colors.orange;
        break;
      case 'finan':
        iconData = Icons.star;
        iconColor = Colors.cyan;
        break;
      case 'credit':
        iconData = Icons.credit_card;
        iconColor = Colors.red;
        break;
      case 'driver':
        iconData = Icons.drive_eta;
        iconColor = Colors.green;
        break;
      case 'tip':
        iconData = Icons.handshake;
        iconColor = Colors.pink;
        break;
      case 's-income':
        iconData = Icons.attach_money;
        iconColor = Colors.blue;
        break;
      case 'invest':
        iconData = Icons.trending_up;
        iconColor = Colors.teal;
        break;
      case 't-income':
        iconData = Icons.money;
        iconColor = Colors.green;
        break;
      case 'refund':
        iconData = Icons.replay;
        iconColor = Colors.green;
        break;
      default:
        iconData = Icons.category;
        iconColor = Colors.blue;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: iconColor, size: 30),
            const SizedBox(height: 4),
            Text(
              category['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}/${now.month}/${now.year} (Th ${now.weekday})";

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần 1: Thanh điều hướng "Tiến chi" và "Tiến thu"
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedType = 'expense';
                          loadCategories();
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedType == 'expense'
                            ? Colors.blue
                            : Colors.grey.shade200,
                      ),
                      child: Text('Tiến chi',
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
                          loadCategories();
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedType == 'income'
                            ? Colors.blue
                            : Colors.grey.shade200,
                      ),
                      child: Text('Tiến thu',
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
            // Phần 2: Trường "Ngày", "Ghi chú", và "Tiền chi"
            TextField(
              decoration: InputDecoration(
                labelText: 'Ngày',
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              controller: TextEditingController(text: formattedDate),
              readOnly: true,
              onTap: () async {
                // Logic chọn ngày (có thể thêm DatePicker)
              },
            ),
            const SizedBox(height: 8),
            TextField(
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
              decoration: InputDecoration(
                labelText: selectedType == 'expense' ? 'Tiền chi' : 'Tiền thu',
                suffixText: 'đ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              controller: TextEditingController(text: '0'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // Phần 3: Danh sách danh mục
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
            // Phần 4: Nút "Nhập khoản chi"
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Xử lý khi nhấn
                  },
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

            // Phần 5: Thanh điều hướng dưới cùng (được xử lý bởi Scaffold.bottomNavigationBar)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}