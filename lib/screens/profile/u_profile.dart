import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/user_profile.dart';
import '../../routes/app_routes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<UserProfile?> _fetchUserProfile() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await Supabase.instance.client
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .single();

    if (response == null || response.isEmpty) return null;

    return UserProfile.fromJson(response);
  }

  void _signOut() async {
    await Supabase.instance.client.auth.signOut();
    Get.offAllNamed(AppRoutes.login); // Chuyển về màn hình đăng nhập
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserProfile?>(
        future: _fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Không tìm thấy thông tin người dùng.'));
          }

          final profile = snapshot.data!;
          final createdAtStr =
          DateFormat('dd/MM/yyyy – HH:mm').format(profile.createdAt);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Phần thông tin người dùng
                const SizedBox(height: 16),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: profile.avatarUrl != null
                        ? NetworkImage(profile.avatarUrl!)
                        : null,
                    child: profile.avatarUrl == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    profile.fullName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text('Ngày tạo tài khoản: $createdAtStr'),
                ),
                const SizedBox(height: 24),

                // Phần danh sách các lựa chọn
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit, color: Colors.blue),
                        title: const Text('Chỉnh sửa thông tin'),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () {
                          //Get.toNamed(AppRoutes.editProfile); // TODO: Tạo route editProfile
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const Divider(height: 1, thickness: 1),
                      ListTile(
                        leading: const Icon(Icons.lock_reset, color: Colors.orange),
                        title: const Text('Đổi mật khẩu'),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () {
                          //Get.toNamed(AppRoutes.changePassword); // TODO: Tạo route changePassword
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const Divider(height: 1, thickness: 1),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Đăng xuất'),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: _signOut,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

    );
  }
}