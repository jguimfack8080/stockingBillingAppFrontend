import 'package:flutter/material.dart';
import '../models/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserCard({
    Key? key,
    required this.user,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Email: ${user.email}'),
              const SizedBox(height: 4),
              Text('Rôle: ${user.role.toUpperCase()}'),
              const SizedBox(height: 4),
              Text('Statut: ${user.status}'),
              const SizedBox(height: 4),
              Text('Date de naissance: ${user.formattedBirthDate}'),
              const SizedBox(height: 4),
              Text('Créé le: ${user.formattedCreatedAt}'),
              if (user.idCardNumber != null) ...[
                const SizedBox(height: 4),
                Text('CNI: ${user.idCardNumber}'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}