import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.digitalkundali.com/api';
  final endpoints = [
    '/auth/password/email',
    '/auth/send-otp',
    '/auth/send-password-reset-otp',
    '/password/email',
    '/forgot-password',
    '/auth/forgot-password-otp',
    '/auth/reset-password/send',
  ];

  for (final endpoint in endpoints) {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': 'shahkiran7777@gmail.com',
      }),
    );
    
    print('Testing $endpoint -> Status: ${response.statusCode}');
    if (response.statusCode != 404) {
      print('Body: ${response.body}\n');
    }
  }
}
