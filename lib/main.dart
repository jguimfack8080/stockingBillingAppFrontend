import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart'; // Ajoutez cet import

import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/user_list_screen.dart';
import 'screens/users/create_user_screen.dart';
import 'screens/users/user_detail_screen.dart';
import 'screens/users/edit_user_screen.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';
import 'services/navigation_service.dart'; // Ajoutez cet import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => UserService()),
      ],
      child: MyApp(initialToken: token),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? initialToken;

  const MyApp({super.key, this.initialToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey, // Utilisez la clé de navigation
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/users': (context) => const UserListScreen(),
        '/users/create': (context) => const CreateUserScreen(),
        '/users/detail': (context) => UserDetailScreen(user: ModalRoute.of(context)!.settings.arguments as User),
        '/users/edit': (context) => EditUserScreen(user: ModalRoute.of(context)!.settings.arguments as User),
      },
    );
  }
}