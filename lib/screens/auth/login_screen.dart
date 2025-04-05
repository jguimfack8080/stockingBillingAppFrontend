import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _errorMessage = null;
      _isSubmitting = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isSubmitting = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),

              CustomTextField(
                controller: _emailController,
                label: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
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
                    return 'Veuillez entrer votre mot de passe';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit avoir au moins 6 caractères';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              _isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Se connecter'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}