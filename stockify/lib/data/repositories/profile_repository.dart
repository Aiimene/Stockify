import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../../config/api_config.dart';

class ProfileRepository {
  static const String _tokenKey = 'auth_token';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token?.trim();
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      final response = await http.get(
        Uri.parse(ApiConfig.userUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Authentication failed. Please login again.',
          'authError': true,
        };
      }

      if (response.statusCode != 200) {
        try {
          final errorData = jsonDecode(response.body) as Map<String, dynamic>;
          return {
            'success': false,
            'message': errorData['message'] as String? ?? 'Failed to fetch profile. Status: ${response.statusCode}',
          };
        } catch (_) {
          return {
            'success': false,
            'message': 'Failed to fetch profile. Status: ${response.statusCode}',
          };
        }
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] == true) {
        try {
          final userJson = data['user'] as Map<String, dynamic>;
          final user = User.fromJson(userJson);
          return {
            'success': true,
            'user': user,
          };
        } catch (e) {
          print('ProfileRepository: Error parsing user data: $e');
          print('ProfileRepository: Response data: $data');
          return {
            'success': false,
            'message': 'Failed to parse user data: ${e.toString()}',
          };
        }
      } else {
        return {
          'success': false,
          'message': data['message'] as String? ?? 'Failed to fetch profile',
        };
      }
    } catch (e) {
      print('ProfileRepository: Network error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? email,
    String? fullName,
    String? password,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      final body = <String, dynamic>{};
      if (email != null && email.isNotEmpty) body['email'] = email.trim();
      if (fullName != null && fullName.isNotEmpty) body['full_name'] = fullName.trim();
      if (password != null && password.isNotEmpty) body['password'] = password;

      final response = await http.post(
        Uri.parse(ApiConfig.userUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Authentication failed. Please login again.',
          'authError': true,
        };
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] == true) {
        final userJson = data['user'] as Map<String, dynamic>;
        final user = User.fromJson(userJson);
        return {
          'success': true,
          'user': user,
          'message': data['message'] as String? ?? 'Profile updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] as String? ?? 'Failed to update profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}

