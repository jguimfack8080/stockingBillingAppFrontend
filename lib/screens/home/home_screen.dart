import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Admin Dashboard'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/users'),
              child: const Text('Manage Users'),
            ),
          ],
        ),
      ),
    );
  }
}