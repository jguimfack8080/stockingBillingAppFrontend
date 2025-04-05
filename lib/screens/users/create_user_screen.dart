import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/role_dropdown.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _idCardController = TextEditingController();
  String _selectedRole = 'cashier';
  DateTime? _birthDate;
  bool _isLoading = false;

Future<void> _submit() async {
  if (!_formKey.currentState!.validate() || _birthDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez remplir tous les champs requis')),
    );
    return;
  }

  setState(() => _isLoading = true);

  final newUser = User(
    firstName: _firstNameController.text.trim(),
    lastName: _lastNameController.text.trim(),
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
    role: _selectedRole,
    idCardNumber: _idCardController.text.trim().isEmpty ? null : _idCardController.text.trim(),
    birthDate: _birthDate!,
    isActive: true,
    createdAt: DateTime.now(),
  );

  final authService = Provider.of<AuthService>(context, listen: false);
  final userService = UserService();

  try {
    await userService.createUser(newUser, authService.token!);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Utilisateur créé avec succès')),
      );
      Navigator.pop(context);
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() => _birthDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un utilisateur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                controller: _firstNameController,
                label: 'Prénom',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prénom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _lastNameController,
                label: 'Nom',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email';
                  }
                  if (!value.contains('@')) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'Mot de passe',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  if (value.length < 6) {
                    return '6 caractères minimum';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _idCardController,
                label: 'Numéro CNI (optionnel)',
              ),
              const SizedBox(height: 16),
              RoleDropdown(
                value: _selectedRole,
                onChanged: (value) => setState(() => _selectedRole = value!),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _birthDate == null
                      ? 'Sélectionner date de naissance'
                      : 'Date: ${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Créer l\'utilisateur'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _idCardController.dispose();
    super.dispose();
  }
}