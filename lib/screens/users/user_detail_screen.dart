import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import 'edit_user_screen.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.fullName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditScreen(context),
          ),
        ],
      ),
      body: _buildUserDetails(),
    );
  }

  void _navigateToEditScreen(BuildContext context) async {
    final shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserScreen(user: user),
      ),
    );
    
    if (shouldRefresh == true) {
      // Rafraîchir les données si nécessaire
      Navigator.pop(context, true);
    }
  }

  Widget _buildUserDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoTile('Email', user.email),
          _buildInfoTile('Rôle', user.role.toUpperCase()),
          _buildInfoTile('Statut', user.isActive ? 'Actif' : 'Inactif'),
          _buildInfoTile('Date de naissance', user.formattedBirthDate),
          _buildInfoTile('Créé le', user.formattedCreatedAt),
          if (user.idCardNumber != null)
            _buildInfoTile('Numéro de CNI', user.idCardNumber!),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}