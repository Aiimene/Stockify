import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../../config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String _tokenKey = 'auth_token';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] == true) {
        final token = data['token'] as String;
        final userJson = data['user'] as Map<String, dynamic>;
        final user = User.fromJson(userJson);

        await _saveToken(token);

        return {
          'success': true,
          'user': user,
          'token': token,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] as String? ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> register(String email, String password, String fullName) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
          'full_name': fullName.trim(),
        }),
      );

      // Handle different HTTP status codes
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          final userJson = data['user'] as Map<String, dynamic>;
          final user = User.fromJson(userJson);

          return {
            'success': true,
            'user': user,
            'message': data['message'] as String? ?? 'Registration successful',
          };
        } else {
          return {
            'success': false,
            'message': data['message'] as String? ?? 'Registration failed',
          };
        }
      } else if (response.statusCode == 400) {
        // Bad request - validation error
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return {
            'success': false,
            'message': data['message'] as String? ?? 'Invalid input. Please check your information.',
          };
        } catch (_) {
          return {
            'success': false,
            'message': 'Invalid input. Please check your information.',
          };
        }
      } else {
        // Other error status codes
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return {
            'success': false,
            'message': data['message'] as String? ?? 'Registration failed. Please try again.',
          };
        } catch (_) {
          return {
            'success': false,
            'message': 'Registration failed. Status: ${response.statusCode}',
          };
        }
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<void> logout() async {
    final token = await getToken();
    if (token != null) {
      try {
        await http.post(
          Uri.parse(ApiConfig.logoutUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } catch (e) {
        // Ignore logout errors
      }
    }
    await _removeToken();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token.trim()); // Store trimmed token
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}

