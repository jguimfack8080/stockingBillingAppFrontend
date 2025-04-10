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
                                        color: user.isActive 
                                            ? Colors.green.shade700 
                                            : Colors.red.shade700,
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
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          color: user.isActive 
                                              ? Colors.blue 
                                              : Colors.grey,
                                          onPressed: user.isActive ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditUserScreen(user: user),
                                              ),
                                            ).then((updated) {
                                              if (updated == true) {
                                                _loadUsers();
                                              }
                                            });
                                          } : null,
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
                                          onPressed: () {
                                            if (user.isActive) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => DeactivateUserScreen(user: user),
                                                ),
                                              ).then((deactivated) {
                                                if (deactivated == true) {
                                                  _loadUsers();
                                                }
                                              });
                                            } else {
                                              // TODO: Implémenter la réactivation d'utilisateur
                                            }
                                          },
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