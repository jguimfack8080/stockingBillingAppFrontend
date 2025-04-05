import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../widgets/role_dropdown.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  const EditUserScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late String _selectedRole;
  late TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.user.role;
    _emailController = TextEditingController(text: widget.user.email);
  }

  Future<void> _submit() async {
    final updatedUser = User(
      id: widget.user.id,
      firstName: widget.user.firstName,
      lastName: widget.user.lastName,
      email: _emailController.text.trim(),
      role: _selectedRole,
      idCardNumber: widget.user.idCardNumber,
      birthDate: widget.user.birthDate,
      isActive: widget.user.isActive,
      createdAt: widget.user.createdAt,
    );

    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = UserService();

    setState(() => _isLoading = true);

    try {
      await userService.updateUser(widget.user.id!, updatedUser, authService.token!);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            RoleDropdown(
              value: _selectedRole,
              onChanged: (value) => setState(() => _selectedRole = value!),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Update User'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}