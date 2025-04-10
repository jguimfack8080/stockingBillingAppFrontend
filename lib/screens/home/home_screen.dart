import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'admin_dashboard.dart';
import 'manager_dashboard.dart';
import 'cashier_dashboard.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Redirection vers le bon tableau de bord selon le rôle
    switch (user.role.toLowerCase()) {
      case 'admin':
        return AdminDashboard(user: user);
      case 'manager':
        return ManagerDashboard(user: user);
      case 'cashier':
        return CashierDashboard(user: user);
      default:
        return Scaffold(
          appBar: AppBar(
            title: const Text('Erreur'),
          ),
          body: const Center(
            child: Text('Rôle non reconnu'),
          ),
        );
    }
  }
}