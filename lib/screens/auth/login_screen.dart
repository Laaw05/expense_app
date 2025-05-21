import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/login_btn.dart';

class LoginScreen extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool _obscureText = true.obs;

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Image.asset(
                "assets/logo1.png",
                width: double.infinity,
                height: 350,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => TextField(
                controller: passwordController,
                obscureText: _obscureText.value,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      _obscureText.value = !_obscureText.value;
                    },
                  ),
                ),
              )),
              const SizedBox(height: 20),
              Obx(() => _authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : LoginBtn(
                onTap: () {
                  _authController.login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                },
                buttonText: 'Đăng nhập',
              )),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Bạn chưa có tài khoản?",
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.register),
                    child: const Text(
                      "Đăng ký",
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
          ),
        ),
      ),
    );
  }
}
