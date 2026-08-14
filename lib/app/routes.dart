import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/main_navigation_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String mainNavigation = '/home';
  static const String adminDashboard = '/admin';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      mainNavigation: (context) => const MainNavigationScreen(),
      adminDashboard: (context) => const AdminDashboardScreen(),
    };
  }
}
