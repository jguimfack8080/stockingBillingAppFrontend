import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import 'navigation_service.dart';

class AuthService with ChangeNotifier {
  String? _token;
  User? _currentUser;
  bool _isLoading = false;

  String? get token => _token;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('$API_BASE_URL/auth/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'username=${Uri.encodeComponent(email)}&password=${Uri.encodeComponent(password)}',
      ).timeout(const Duration(seconds: 10));

      log('Login API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final tokenResponse = json.decode(response.body);
        _token = tokenResponse['access_token'];
        
        if (_token == null) {
          throw 'Erreur technique : Aucun token reçu du serveur';
        }

        final payload = _decodeJwtPayload(_token!);
        
        _currentUser = User(
          id: payload['id'] as int? ?? 0,
          firstName: payload['first_name'] as String? ?? 'Admin',
          lastName: payload['last_name'] as String? ?? 'User',
          email: payload['sub'] as String? ?? email,
          role: payload['role'] as String? ?? 'user',
          idCardNumber: payload['id_card_number'] as String? ?? '',
          birthDate: payload['birth_date'] != null 
              ? DateTime.parse(payload['birth_date'] as String) 
              : DateTime.now(),
          isActive: payload['is_active'] as bool? ?? true,
          createdAt: payload['created_at'] != null
              ? DateTime.parse(payload['created_at'] as String)
              : DateTime.now(),
        );

        await _saveTokenToStorage(_token!);
        
        // Navigation vers le bon tableau de bord selon le rôle
        switch (_currentUser!.role.toLowerCase()) {
          case 'admin':
            NavigationService.replaceWith('/admin-dashboard', arguments: _currentUser);
            break;
          case 'manager':
            NavigationService.replaceWith('/manager-dashboard', arguments: _currentUser);
            break;
          case 'cashier':
            NavigationService.replaceWith('/cashier-dashboard', arguments: _currentUser);
            break;
          default:
            NavigationService.replaceWith('/home', arguments: _currentUser);
        }
      } else {
        throw _handleLoginError(response);
      }
    } on TimeoutException {
      throw 'La connexion a pris trop de temps. Veuillez vérifier votre connexion internet.';
    } on http.ClientException {
      throw 'Erreur de réseau. Veuillez vérifier votre connexion internet.';
    } on FormatException {
      throw 'Erreur technique : Réponse invalide du serveur';
    } catch (e) {
      log('Login error: $e', stackTrace: StackTrace.current);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _handleLoginError(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      final statusCode = response.statusCode;
      
      switch (statusCode) {
        case 400:
          return errorData['detail'] ?? 'Requête invalide. Veuillez vérifier vos informations.';
        case 401:
          return 'Email ou mot de passe incorrect';
        case 403:
          return 'Accès refusé. Votre compte peut être désactivé.';
        case 404:
          return 'Service non trouvé. Veuillez contacter le support.';
        case 500:
          return 'Erreur serveur. Veuillez réessayer plus tard.';
        default:
          return 'Erreur inconnue (Code: $statusCode)';
      }
    } catch (e) {
      return 'Erreur technique lors de la connexion';
    }
  }

  Map<String, dynamic> _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw 'Format de token invalide';
      }

      String payload = parts[1];
      payload = payload.padRight(payload.length + (4 - payload.length % 4) % 4, '=');
      payload = payload.replaceAll('-', '+').replaceAll('_', '/');
      
      return json.decode(utf8.decode(base64.decode(payload)));
    } catch (e) {
      log('JWT decode error: $e');
      throw 'Erreur technique : Impossible de lire les informations utilisateur';
    }
  }

  Future<void> _saveTokenToStorage(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } catch (e) {
      log('Token save error: $e');
      throw 'Erreur technique : Impossible de sauvegarder la session';
    }
  }

  Future<bool> autoLogin() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) return false;

      final payload = _decodeJwtPayload(token);
      
      _currentUser = User(
        id: payload['id'] as int? ?? 0,
        firstName: payload['first_name'] as String? ?? 'Admin',
        lastName: payload['last_name'] as String? ?? 'User',
        email: payload['sub'] as String? ?? '',
        role: payload['role'] as String? ?? 'user',
        idCardNumber: payload['id_card_number'] as String? ?? '',
        birthDate: payload['birth_date'] != null 
            ? DateTime.parse(payload['birth_date'] as String) 
            : DateTime.now(),
        isActive: payload['is_active'] as bool? ?? true,
        createdAt: payload['created_at'] != null
            ? DateTime.parse(payload['created_at'] as String)
            : DateTime.now(),
      );

      _token = token;
      return true;
    } catch (e) {
      log('Auto-login error: $e');
      await logout();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      
      _token = null;
      _currentUser = null;
      
      NavigationService.navigateAndRemoveUntil(AppRoutes.login);
    } catch (e) {
      log('Logout error: $e', stackTrace: StackTrace.current);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}