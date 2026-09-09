import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

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

  static Future<Map<String, dynamic>> googleLogin() async {
    final url = Uri.parse('$baseUrl/auth/google');
    
    try {
      // Initialize GoogleSignIn using the Web Client ID from Google Cloud Console
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: '1084761234012-ulut15lblmcf3ee59fo4kqgvpkda4qqo.apps.googleusercontent.com', // <-- Replace with your Google Cloud Console Web Client ID
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        return {
          'success': false,
          'message': 'Google login cancelled',
        };
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // We send the Google ID token to the backend
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'id_token': googleAuth.idToken,
        }),
      );

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        token = decodedData['token'] ?? decodedData['data']?['token'] ?? token;
        userId = decodedData['user']?['id']?.toString() ?? decodedData['data']?['user']?['id']?.toString() ?? userId;
        return {
          'success': true,
          'data': decodedData,
        };
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Google Login failed',
          'errors': decodedData['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Google Login error: ${e.toString()}',
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
