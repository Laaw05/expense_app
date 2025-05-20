import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/login_btn.dart';
class LoginScreen extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Image.asset(
              "assets/logo1.png",
              width: double.maxFinite,
              height: 250,
              fit: BoxFit.cover,
            ),
            TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                )),
            SizedBox(height: 20),
            TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility),)
                ),
                obscureText: true),
            const SizedBox(height: 20),
            Obx(() => _authController.isLoading.value
                ? const CircularProgressIndicator()
                : LoginBtn(
              onTap: () {
                _authController.login(
                    emailController.text, passwordController.text);
              },
              buttonText: 'Đăng nhập',
              // color: Colors.blue, // bạn có thể thêm nếu muốn đổi màu nút
            )),

            TextButton(
                onPressed: () => Get.toNamed(AppRoutes.register),
                child: const Text("Bạn đã có tài khoản chưa? Đăng ký"))
          ],
        ),
      ),
    );
  }
}
