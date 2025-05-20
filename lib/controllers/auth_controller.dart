import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    final user = await _authService.signIn(email, password);
    isLoading.value = false;

    if (user != null) {
      Get.offNamed(AppRoutes.home);
    } else {
      Get.snackbar('Lỗi', 'Email hoặc mật khẩu không đúng');
    }
  }

  Future<void> register(String email, String password) async {
    isLoading.value = true;
    final user = await _authService.signUp(email, password);
    isLoading.value = false;

    if (user != null) {
      Get.snackbar('Thành công', 'Đăng ký thành công, hãy kiểm tra email để xác nhận');
      Get.offNamed(AppRoutes.login);
    } else {
      Get.snackbar('Lỗi', 'Không thể đăng ký. Vui lòng thử lại.');
    }
  }
}
