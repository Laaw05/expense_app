import 'package:get/get.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';

import '../screens/report/report_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/categories/cat_home.dart';
import '../screens/categories/add_cat.dart';
import '../screens/profile/u_profile.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.login, page: () => LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => RegisterScreen()),
    GetPage(name: AppRoutes.home, page: () => HomeScreen()),
    GetPage(name: AppRoutes.report, page: () => ReportScreen()),
    GetPage(name: AppRoutes.settings, page: () => SettingsScreen()),
    GetPage(
      name: AppRoutes.expenseCat,
      page: () => const ExpenseCategoryScreen(),
    ),
    GetPage(
      name: AppRoutes.addCategory,
      page: () {
        final type = Get.arguments as String? ?? 'expense';
        return AddCategoryPage(type: type);
      },
    ),
    GetPage(name: AppRoutes.profile, page: () => UserProfileScreen()),
  ];
}
