import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/user_update_data.dart';
import '../models/user_deactivation.dart';
import '../utils/constants.dart';
import 'api_service.dart';
import 'auth_service.dart';

class UserService {
  final ApiService _apiService = ApiService();
  final AuthService _authService;

  UserService(this._authService);

  Future<List<User>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$API_BASE_URL/users/'),
      headers: {
        'Authorization': 'Bearer ${_authService.token}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw 'Erreur lors de la récupération des utilisateurs: ${response.statusCode}';
    }
  }

  Future<User> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
    required String idCardNumber,
    required DateTime birthDate,
  }) async {
    final token = _authService.token;
    if (token == null) {
      throw Exception('Token non disponible');
    }

    final response = await http.post(
      Uri.parse('$API_BASE_URL/users/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'role': role,
        'id_card_number': idCardNumber,
        'birth_date': birthDate.toIso8601String().split('T')[0],
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Erreur lors de la création de l\'utilisateur: ${response.statusCode} ${response.body}');
    }
  }

  Future<User> updateUser({
    required int userId,
    String? email,
    String? role,
    String? firstName,
    String? lastName,
    String? idCardNumber,
    DateTime? birthDate,
  }) async {
    final token = _authService.token;
    if (token == null) {
      throw Exception('Token d\'authentification manquant');
    }

    final Map<String, dynamic> updateData = {};
    
    if (email != null) updateData['email'] = email;
    if (role != null) updateData['role'] = role;
    if (firstName != null) updateData['first_name'] = firstName;
    if (lastName != null) updateData['last_name'] = lastName;
    if (idCardNumber != null) updateData['id_card_number'] = idCardNumber;
    if (birthDate != null) {
      updateData['birth_date'] = birthDate.toIso8601String().split('T')[0];
    }

    final response = await http.put(
      Uri.parse('$API_BASE_URL/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(updateData),
    );

    if (response.statusCode == 200) {
      // Si la réponse a un corps, on le décode
      if (response.body.isNotEmpty) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Créer un nouvel objet User avec les données mises à jour
        return User(
          id: userId,
          firstName: responseData['first_name'] ?? firstName ?? '',
          lastName: responseData['last_name'] ?? lastName ?? '',
          email: responseData['email'] ?? email ?? '',
          role: responseData['role'] ?? role ?? 'user',
          idCardNumber: responseData['id_card_number'] ?? idCardNumber,
          birthDate: responseData['birth_date'] != null 
              ? DateTime.parse(responseData['birth_date']) 
              : birthDate ?? DateTime.now(),
          isActive: responseData['is_active'] ?? true,
          createdAt: responseData['created_at'] != null 
              ? DateTime.parse(responseData['created_at']) 
              : DateTime.now(),
        );
      }
      // Si la réponse est vide, on retourne un utilisateur avec les données mises à jour
      return User(
        id: userId,
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        email: email ?? '',
        role: role ?? 'user',
        idCardNumber: idCardNumber,
        birthDate: birthDate ?? DateTime.now(),
        isActive: true,
        createdAt: DateTime.now(),
      );
    } else {
      throw Exception('Erreur lors de la mise à jour de l\'utilisateur: ${response.body}');
    }
  }

  Future<void> deactivateUser(int userId, String reason) async {
    final token = _authService.token;
    if (token == null) {
      throw Exception('Token non disponible');
    }

    final response = await http.put(
      Uri.parse('$API_BASE_URL/users/deactivate/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(UserDeactivation(reason: reason).toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la désactivation de l\'utilisateur: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> reactivateUser(int userId) async {
    final token = _authService.token;
    if (token == null) {
      throw Exception('Token non disponible');
    }

    final response = await http.put(
      Uri.parse('$API_BASE_URL/users/deactivate/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(UserDeactivation(reason: 'Réactivation', isDeactivating: false).toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la réactivation de l\'utilisateur: ${response.statusCode} ${response.body}');
    }
  }
}