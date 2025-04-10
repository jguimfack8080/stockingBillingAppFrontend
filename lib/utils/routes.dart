import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/user_list_screen.dart';
import '../models/user.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String adminDashboard = '/admin-dashboard';
  static const String managerDashboard = '/manager-dashboard';
  static const String cashierDashboard = '/cashier-dashboard';
  static const String userList = '/users';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case userList:
        return MaterialPageRoute(builder: (_) => const UserListScreen());
      case home:
      case adminDashboard:
      case managerDashboard:
      case cashierDashboard:
        final user = settings.arguments as User?;
        if (user == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('Erreur: Utilisateur non fourni pour ${settings.name}'),
              ),
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => HomeScreen(user: user));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route non définie pour ${settings.name}'),
            ),
          ),
        );
    }
  }
} 