import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://api.digitalkundali.com/api';
  static String? token; // Store token for API requests
  static String? userId; // Store user ID to isolate local cache
  

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Assuming API returns token in data.token or token
        token = decodedData['token'] ?? decodedData['data']?['token'] ?? token;
        userId = decodedData['user']?['id']?.toString() ?? decodedData['data']?['user']?['id']?.toString() ?? userId;
        return {
          'success': true,
          'data': decodedData,
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Registration failed',
          'errors': decodedData['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred. Please try again.',
      };
    }
  }
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('LOGIN RESPONSE: $decodedData'); // Added for debugging
        token = decodedData['token'] ?? decodedData['access_token'] ?? decodedData['data']?['token'] ?? decodedData['data']?['access_token'] ?? token;
        userId = decodedData['user']?['id']?.toString() ?? decodedData['data']?['user']?['id']?.toString() ?? userId;
        print('EXTRACTED TOKEN: $token, USER ID: $userId');
        return {
          'success': true,
          'data': decodedData,
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Login failed',
          'errors': decodedData['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred. Please try again.',
      };
    }
  }

  static Future<void> logout() async {
    if (token != null) {
      try {
        final url = Uri.parse('$baseUrl/auth/logout');
        await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } catch (e) {
        print('Logout network error ignored: $e');
      }
    }
    token = null;
    userId = null;
  }
}
