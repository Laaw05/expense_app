import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Nhập lại mật khẩu'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _authController.isLoading.value
                  ? null
                  : () {
                final email = _emailController.text.trim();
                final password = _passwordController.text.trim();
                final confirm = _confirmPasswordController.text.trim();

                if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
                  Get.snackbar('Lỗi', 'Vui lòng điền đầy đủ thông tin');
                  return;
                }

                if (password != confirm) {
                  Get.snackbar('Lỗi', 'Mật khẩu không khớp');
                  return;
                }

                _authController.register(email, password);
              },
              child: _authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text('Đăng ký'),
            ),
            TextButton(
              onPressed: () => Get.offNamed(AppRoutes.login),
              child: const Text('Đã có tài khoản? Đăng nhập'),
            ),
          ],
        )),
      ),
    );
  }
}
