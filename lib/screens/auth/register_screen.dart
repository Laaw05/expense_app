import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/regis_btn.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _authController = Get.find<AuthController>();

  final RxBool _obscurePassword = true.obs;
  final RxBool _obscureConfirmPassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/logo1.png",
                width: double.infinity,
                height: 350,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              Obx(() => TextField(
                controller: _passwordController,
                obscureText: _obscurePassword.value,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword.value
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      _obscurePassword.value =
                      !_obscurePassword.value;
                    },
                  ),
                ),
              )),
              const SizedBox(height: 20),
              Obx(() => TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword.value,
                decoration: InputDecoration(
                  labelText: 'Nhập lại mật khẩu',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword.value
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      _obscureConfirmPassword.value =
                      !_obscureConfirmPassword.value;
                    },
                  ),
                ),
              )),
              const SizedBox(height: 24),
              _authController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : RegisterBtn(
                buttonText: 'Đăng ký',
                onTap: () {
                  final email =
                  _emailController.text.trim();
                  final password =
                  _passwordController.text.trim();
                  final confirm =
                  _confirmPasswordController.text.trim();

                  if (email.isEmpty ||
                      password.isEmpty ||
                      confirm.isEmpty) {
                    Get.snackbar('Lỗi', 'Vui lòng điền đầy đủ thông tin');
                    return;
                  }

                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(email)) {
                    Get.snackbar('Lỗi', 'Email không hợp lệ');
                    return;
                  }

                  if (password.length < 6) {
                    Get.snackbar('Lỗi', 'Mật khẩu phải từ 6 ký tự');
                    return;
                  }

                  if (password != confirm) {
                    Get.snackbar('Lỗi', 'Mật khẩu không khớp');
                    return;
                  }

                  _authController.register(email, password);
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Bạn đã có tài khoản rồi?",
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.login),
                    child: const Text(
                      "Đăng nhập",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}
