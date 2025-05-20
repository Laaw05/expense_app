import 'package:get/get.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/transactions/transaction_list_screen.dart';
import '../screens/transactions/add_transaction_screen.dart';
import '../screens/report/report_screen.dart';
import '../screens/accounts/accounts_screen.dart';
import '../screens/settings/settings_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.login, page: () => LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => RegisterScreen()),
    GetPage(name: AppRoutes.home, page: () => HomeScreen()),
    GetPage(name: AppRoutes.transactions, page: () => TransactionListScreen()),
    GetPage(name: AppRoutes.addTransaction, page: () => AddTransactionScreen()),
    GetPage(name: AppRoutes.report, page: () => ReportScreen()),
    GetPage(name: AppRoutes.accounts, page: () => AccountsScreen()),
    GetPage(name: AppRoutes.settings, page: () => SettingsScreen()),
  ];
}
