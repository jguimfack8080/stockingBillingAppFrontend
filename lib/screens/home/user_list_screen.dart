import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import '../users/create_user_screen.dart';
import '../users/user_detail_screen.dart';
import '../users/edit_user_screen.dart';
import '../users/deactivate_user_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _users.where((user) {
        final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
        final email = user.email.toLowerCase();
        final role = user.role.toLowerCase();
        return fullName.contains(query) || 
               email.contains(query) || 
               role.contains(query);
      }).toList();
    });
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userService = Provider.of<UserService>(context, listen: false);
      final users = await userService.getAllUsers();
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDeactivateUser(User user) async {
    final userService = Provider.of<UserService>(context, listen: false);
    
    if (user.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur: ID utilisateur manquant')),
      );
      return;
    }
    
    if (!user.isActive) {
      // Réactiver l'utilisateur
      try {
        await userService.reactivateUser(user.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Utilisateur réactivé avec succès')),
        );
        _loadUsers();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la réactivation: $e')),
        );
      }
    } else {
      // Désactiver l'utilisateur
      final TextEditingController reasonController = TextEditingController();
      final reason = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Désactiver l\'utilisateur'),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(
              labelText: 'Raison de la désactivation',
              hintText: 'Entrez la raison de la désactivation',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, reasonController.text),
              child: const Text('Confirmer'),
            ),
          ],
        ),
      );

      if (reason != null && reason.isNotEmpty) {
        try {
          await userService.deactivateUser(user.id!, reason);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Utilisateur désactivé avec succès')),
          );
          _loadUsers();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de la désactivation: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Utilisateurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher un utilisateur',
                hintText: 'Nom, email ou rôle...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadUsers,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : _filteredUsers.isEmpty
                        ? const Center(
                            child: Text('Aucun utilisateur trouvé'),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadUsers,
                            child: ListView.builder(
                              itemCount: _filteredUsers.length,
                              itemBuilder: (context, index) {
                                final user = _filteredUsers[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: user.isActive 
                                          ? Colors.green.shade100 
                                          : Colors.red.shade100,
                                      child: Icon(
                                        user.isActive ? Icons.person : Icons.person_off,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            user.fullName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: user.isActive 
                                                  ? Colors.black 
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: user.isActive 
                                                ? Colors.green.shade50 
                                                : Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: user.isActive 
                                                  ? Colors.green.shade200 
                                                  : Colors.red.shade200,
                                            ),
                                          ),
                                          child: Text(
                                            user.isActive ? 'Actif' : 'Inactif',
                                            style: TextStyle(
                                              color: user.isActive 
                                                  ? Colors.green.shade700 
                                                  : Colors.red.shade700,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.email,
                                          style: TextStyle(
                                            color: user.isActive 
                                                ? Colors.black54 
                                                : Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              _getRoleIcon(user.role),
                                              size: 16,
                                              color: user.isActive 
                                                  ? Colors.blue.shade700 
                                                  : Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              user.role,
                                              style: TextStyle(
                                                color: user.isActive 
                                                    ? Colors.blue.shade700 
                                                    : Colors.grey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (!user.isActive && user.deactivationReason != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Raison: ${user.deactivationReason}',
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: user.isActive
                                              ? () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => EditUserScreen(user: user),
                                                    ),
                                                  )
                                              : null,
                                          color: user.isActive ? null : Colors.grey,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            user.isActive 
                                                ? Icons.person_off 
                                                : Icons.person_add,
                                            color: user.isActive 
                                                ? Colors.red 
                                                : Colors.green,
                                          ),
                                          onPressed: () => _handleDeactivateUser(user),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UserDetailScreen(user: user),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateUserScreen(),
            ),
          ).then((created) {
            if (created == true) {
              _loadUsers();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'manager':
        return Icons.manage_accounts;
      case 'cashier':
        return Icons.point_of_sale;
      default:
        return Icons.person;
    }
  }
}