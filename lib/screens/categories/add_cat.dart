import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class AddCategoryPage extends StatefulWidget {
  final String type;

  const AddCategoryPage({Key? key, required this.type}) : super(key: key);

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedIcon;

  final List<String> _icons = [
    '🛒', '🚕', '✈️', '🍔', '🍰', '👗', '🎥', '☕️',
    '🚢', '🍩', '🎬', '🍞', '⭐️', '👗', '👖', '🍷',
  ];

  Future<void> _saveCategory() async {
    final name = _nameController.text.trim();
    final icon = _selectedIcon ?? '';
    final type = widget.type;

    if (name.isEmpty || icon.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final response = await Supabase.instance.client.from('categories').insert({
      'user_id': userId,
      'name': name,
      'icon': icon,
      'type': type,
    });

    if (response.error == null) {
      Get.back();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${response.error!.message}')),
      );
    }
  }

  Widget _buildIconGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _icons.map((icon) {
        final isSelected = icon == _selectedIcon;
        return GestureDetector(
          onTap: () => setState(() => _selectedIcon = icon),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(icon, style: TextStyle(fontSize: 28)),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.type == 'expense' ? 'Thêm danh mục chi' : 'Thêm danh mục thu';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tên', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Nhập tên danh mục'),
            ),
            SizedBox(height: 20),
            Text('Biểu tượng', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildIconGrid(),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _saveCategory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('Lưu', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
