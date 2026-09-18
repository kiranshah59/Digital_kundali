import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  final baseUrl = 'https://api.digitalkundali.com/api';
  
  // 1. Register/Login a test user
  final registerUrl = Uri.parse('$baseUrl/auth/register');
  final registerRes = await http.post(
    registerUrl,
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    body: jsonEncode({
      'name': 'Test User',
      'email': 'test_esewa_12345@example.com',
      'password': 'password123',
      'password_confirmation': 'password123',
    }),
  );
  
  String token = '';
  if (registerRes.statusCode >= 200 && registerRes.statusCode < 300) {
    final data = jsonDecode(registerRes.body);
    token = data['token'] ?? '';
  } else {
    // try login
    final loginUrl = Uri.parse('$baseUrl/auth/login');
    final loginRes = await http.post(
      loginUrl,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'email': 'test_esewa_12345@example.com',
        'password': 'password123',
      }),
    );
    final data = jsonDecode(loginRes.body);
    token = data['token'] ?? '';
  }

  print('Token: $token');

  if (token.isEmpty) {
    print('Failed to get token');
    return;
  }

  // 2. Initiate eSewa payment
  final initiateUrl = Uri.parse('$baseUrl/payments/esewa/initiate');
  final initRes = await http.post(
    initiateUrl,
    headers: {
      'Content-Type': 'application/json', 
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({'plan_id': 2}),
  );

  print('Status: ${initRes.statusCode}');
  print('Body: ${initRes.body}');
}
