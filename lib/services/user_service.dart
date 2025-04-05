import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<List<User>> getUsers(String token) async {
    final response = await _apiService.get('users/', token);
    
    log('Users API Response: ${response.body}');
    
    try {
      final List<dynamic> data = json.decode(response.body);
      return data.map((userJson) => User.fromJson(userJson)).toList();
    } catch (e) {
      log('Error parsing users: $e');
      throw Exception('Failed to parse users data');
    }
  }

  Future<User> createUser(User user, String token) async {
    try {
      // Créez un payload spécifique pour la création
      final payload = {
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
        'password': user.password,
        'role': user.role,
        'id_card_number': user.idCardNumber,
        'birth_date': user.birthDate.toIso8601String().split('T')[0], // Format YYYY-MM-DD
      };

      log('Creating user with payload: $payload');

      final response = await _apiService.post(
        'users/',
        payload,
        token,
      );

      log('Create user response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error['detail'] ?? 'Failed to create user');
      }
    } catch (e) {
      log('Create user error: $e');
      throw Exception('Failed to create user: ${e.toString()}');
    }
  }

  Future<User> updateUser(int userId, User user, String token) async {
    final response = await _apiService.put(
      'users/$userId',
      user.toJson(),
      token,
    );
    return User.fromJson(json.decode(response.body));
  }
}