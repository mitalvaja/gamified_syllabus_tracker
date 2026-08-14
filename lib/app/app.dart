import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';
import '../providers/syllabus_provider.dart';
import '../providers/planner_provider.dart';
import '../providers/gamification_provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/report_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/admin_provider.dart';
import '../providers/game_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/main_navigation_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import 'routes.dart';
import 'theme.dart';

class GamifiedSyllabusApp extends StatelessWidget {
  const GamifiedSyllabusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SyllabusProvider()),
        ChangeNotifierProvider(create: (_) => PlannerProvider()),
        ChangeNotifierProvider(create: (_) => GamificationProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routes: AppRoutes.routes,
            home: auth.isAuthenticated
                ? (auth.isAdmin
                    ? const AdminDashboardScreen()
                    : const MainNavigationScreen())
                : const LoginScreen(),
          );
        },
      ),
    );
  }
}
