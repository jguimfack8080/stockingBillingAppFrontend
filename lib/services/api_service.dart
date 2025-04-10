import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  final String _baseUrl = API_BASE_URL;

  Future<http.Response> get(String endpoint, String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(token),
    );
    return _handleResponse(response);
  }

  Future<http.Response> post(String endpoint, dynamic body, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(token),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<http.Response> put(String endpoint, dynamic body, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(token),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}