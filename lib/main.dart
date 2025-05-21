import 'package:expense_app/screens/auth/login_screen.dart';
import 'package:expense_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';
import 'services/supabase_config.dart';
import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  Get.put(AuthController());

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: AppRoutes.login,
    getPages: AppPages.routes,
    home: AuthCheck(), // Thêm AuthCheck làm home của ứng dụng
  ));
}

// Widget AuthCheck để kiểm tra trạng thái xác thực
class AuthCheck extends StatelessWidget {
  final supabase = Supabase.instance.client;

  AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = supabase.auth.currentSession;
        if (session != null) {
          return HomeScreen(); // Nếu đã đăng nhập, đi tới HomeScreen
        } else {
          return LoginScreen(); // Nếu không, hiển thị LoginScreen
        }
      },
    );
  }
}