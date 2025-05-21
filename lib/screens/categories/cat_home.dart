import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/category_service.dart';
import '../../routes/app_routes.dart';
import 'package:get/get.dart';

class ExpenseCategoryScreen extends StatefulWidget {
  const ExpenseCategoryScreen({super.key});

  @override
  State<ExpenseCategoryScreen> createState() => _ExpenseCategoryScreenState();
}

class _ExpenseCategoryScreenState extends State<ExpenseCategoryScreen> {
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
      _futureCategories =
          CategoryService().getCategoriesByType(userId: userId, type: selectedType);
    } else {
      _futureCategories = Future.value([]);
    }
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return ListTile(
      leading: const Icon(Icons.category),
      title: Text(category['name']),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục'),
        actions: [
          TextButton(
            onPressed: () {
            },
            child: const Text('Chỉnh sửa', style: TextStyle(color: Colors.white)),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
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
                    backgroundColor:
                    selectedType == 'expense' ? Colors.blue : Colors.grey.shade200,
                  ),
                  child: Text('Chi tiêu',
                      style: TextStyle(
                        color: selectedType == 'expense' ? Colors.white : Colors.black,
                      )),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedType = 'income';
                      loadCategories();
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                    selectedType == 'income' ? Colors.blue : Colors.grey.shade200,
                  ),
                  child: Text('Thu nhập',
                      style: TextStyle(
                        color: selectedType == 'income' ? Colors.white : Colors.black,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Thêm danh mục'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Get.toNamed(AppRoutes.addCategory, arguments: selectedType);
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có danh mục nào'));
                }

                final categories = snapshot.data!;
                return ListView.separated(
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) =>
                      _buildCategoryItem(categories[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
